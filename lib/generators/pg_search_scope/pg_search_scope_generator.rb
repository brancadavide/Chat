class PgSearchScopeGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :columns, type: :array, desc: "Model column column..."

  def run_pg
  	if model_exist?
				if include_pg_search_exists? 
  				inject_into_file model_path, "\n  #{create_search_string}", after: "PgSearch"
  			else
  				inject_into_file model_path,"\n include PgSearch\n  #{create_search_string}" ,after: "< ApplicationRecord" 

  			end
  		else 
  			puts "Model #{class_name.camelize} nicht vorhanden!"
  		end
  end

  private

  def create_search_string
  		%Q{pg_search_scope :search_#{class_name.underscore}, against: [#{columns.map { |column| ":#{column}"}.join(",")}], using: { tsearch: { prefix: true} }\n }
  end

    
  def model_exist?
  	File.exists?(model_path)
  end

  def model_path
  	File.join(base_model_path,"#{class_name.underscore}.rb")
  end

  def base_model_path
  	File.join(Rails.root,"app/models")
  end

  def model_content
  	File.read(model_path)
  end

  def include_pg_search_exists?
  	model_content.match(/(include PgSearch)/)
  end

end
