namespace :copycopter do
  task :regenerate_project_caches => :environment do
    Project.regenerate_caches
  end

  desc 'Add a project to Copycopter'
  task :project => :environment do
    project = Project.new(name: ENV['NAME'])

    if project.save
      puts "Project #{project.name} created!"
    else
      puts "There were errors creating the project: #{project.errors.full_messages}"
    end
  end
end
