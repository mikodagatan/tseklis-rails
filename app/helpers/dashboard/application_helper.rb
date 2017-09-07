module Dashboard::ApplicationHelper

  def better_file_size(file_size)
    number_with_delimiter(file_size, delimiter: ',', precision: 2)
  end
end
