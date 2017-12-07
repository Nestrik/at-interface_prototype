require 'json'
require 'yaml'

class TestExecutor
  def initialize
    @wp = false #work in progress
    @syslog = 'Начало лога<br/>'
    @test = true
  end

  def log
    rlog = @syslog.gsub(Regexp.new('\n'), '<br/>')
    result = {wp: @wp, log: rlog}.to_json
    puts result
    result
  end

  def testprepare(project)
    @wp = true
    testdata(project)
    config?(project) ? sys_styler("data/#{project}", 'bundle exec ruby scripts/run_all.rb') :
                       sys_styler('Please create config file at path: /data/#{prooject}/lib/configs/run.yml')
    @wp = false
  end

  def create_config(params)
    f = File.new('data/#{params[project]}/lib/configs/run.yml', 'w')
    required_params = params
    required_params = run_config_sanitize(required_params)
    required_params.each { |key, value| f.puts("#{key}: #{value}") }
    f.close
    sys_styler("maked config file: /data/#{params[project]}/lib/configs/run.yml")
  end

  def run_params_validation(params)
    params = JSON.parse(params)
    error = "Не указан stand" if params[:stand] == nil
    error = "Неверно указан stand" if params[:stand] != nil && (params[:stand].downcase =~ /(1|2|3|4|5|6|knife)/) == nil
    error = "Не указан субдомен контейнера ножа" if params[:knife_domain] == nil && params[:stand] == 'knife'
    if (params[:httpa]) then
      error = "Укажите логин http авторизации"  && params[:httpa_login] == nil
      error = "Укажите пароль http авторизации"  && params[:httpa_pass] == nil
    end
    error
  end

  private
  def run_config_sanitize(data_hash)
    data_hash.delete(:project)
    data_hash.delete(:httpa_login) if !data_hash(:httpa)
    data_hash.delete(:httpa_pass) if !data_hash(:httpa)
    data_hash
  end

  def sys_styler(dir=nil, command)
    text = (dir == nil) ? "#{command}" : "#{dir} > run \'#{command}\'"
    @syslog << "<p style=\"color: green;\">#{text}</p>"
    @syslog << Dir.chdir("#{dir}") { `#{command}` } if (dir != nil)
  end

  def testdata(project)
    if File.directory?("data/#{project}") then
      sys_styler("data/#{project}", 'git pull')
      sys_styler("data/#{project}", 'bundle update')
    else
      sys_styler('data', "git clone https://github.com/abak-press/#{project}.git")
      sys_styler("data/#{project}", 'bundle install')
    end
  end

  def config?(project)
    file_path = "data/#{project}/lib/configs/run.yml"
    if File.exist?(file_path) then
      sys_styler("Test run with config:")
      run_config = YAML.load_file(file_path)
      run_config.each do |key, value|
        sys_styler("#{key} : #{value} <br/>")
      end
    else
      sys_styler("Config file not found!")
    end
  end
end
