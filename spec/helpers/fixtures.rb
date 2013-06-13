module Fixtures

  def fixture_file(file)
    path = File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', file))
    IO.read path
  end

end
