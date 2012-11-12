require 'spec_helper'

describe DefaultCreator do
  let!(:project) { Factory(:project) }

  def create_defaults(defaults)
    DefaultCreator.new(project, defaults).create
    project.reload
  end

  def draft_hash
    Yajl::Parser.parse(project.draft_json)
  end

  it 'sets draft content for a list of blurbs' do
    locale = project.locales.first
    one = Factory(:blurb, :project => project, :key => 'test.one')
    Factory :localization, :blurb             => one,
                           :locale            => locale,
                           :draft_content     => 'draft one',
                           :published_content => 'published one'

    two = Factory :blurb, :project => project, :key => 'test.two'
    Factory :localization, :blurb             => two,
                           :locale            => locale,
                           :draft_content     => 'draft two',
                           :published_content => 'published two'

    create_defaults 'us.test.one' => 'new one', 'us.test.three' => 'new three'
    project.localizations(true).map(&:draft_content).should =~ ['draft one', 'draft two', 'new three']
    project.localizations.map(&:published_content).should =~ ['', 'published one', 'published two']
  end

  it 'ignores blank keys' do
    create_defaults 'us.test.one' => 'not blank', '' => 'blank'
    project.localizations(true).map(&:draft_content).should =~ ['not blank']
  end

  it "only updates the project once when creating several defaults" do
    Project.connection.stubs :update
    create_defaults 'us.test.one' => 'value', 'us.test.two' => 'other'
    Project.connection.should update_table("projects").once
  end

  it 'creates missing locales' do
    create_defaults 'us.test' => 'value', 'us.test' => 'valor'
    project.draft_json.should == Yajl::Encoder.encode(
      'us.test' => 'value', 'us.test' => 'valor'
    )
  end

  it 'activates after creating a blurb' do
    create_defaults('us.test' => 'value')
    project.reload.should be_active
  end

  it 'creates defaults in all locales' do
    create_defaults 'us.test' => 'value', 'es.test' => 'valor',
      'us.other' => 'other'

    draft_hash.should == {
      'us.test' => 'value',
      'es.test' => 'valor',
      'us.other' => 'other',
      'es.other' => 'other'
    }
  end

  it 'uses blank copy for blurbs without a default for the default locale' do
    create_defaults 'es.test' => 'valor'

    draft_hash.should == {
      'us.test' => '',
      'es.test' => 'valor'
    }
  end

  it 'fills in defaults for new locales' do
    create_defaults 'us.one' => 'one', 'us.two' => 'two'
    create_defaults 'es.one' => 'uno'

    draft_hash.should == {
      'us.one' => 'one',
      'es.one' => 'uno',
      'us.two' => 'two',
      'es.two' => 'two'
    }
  end
end
