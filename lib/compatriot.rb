require "compatriot/version"
require "compatriot/runner"
require "compatriot/browser"
require "compatriot/results_presenter"
require "compatriot/image_differ/image_differ"

module Compatriot
  class << self
    attr_accessor :app, :screenshot_directory

    def configure
      yield self
    end

    def run(paths)
      Compatriot::Runner.start(app, paths)
    end

    def take_screenshot(page, test, description)
      filename = filename_for_test(test, description)
      control_image_path = filepath_for_screenshot('control', filename)
      variable_image_path = filepath_for_screenshot('variable', filename)

      if File.exist?(control_image_path)
        screenshot_type = 'variable'
      else
        screenshot_type = 'control'
      end
      temp = page.save_screenshot filepath_for_screenshot(screenshot_type, filename)
    end

    def percentage_changed(page, test, description = '')
      variable_img_path = take_screenshot(page, test, description)
      control_img_path = filepath_for_screenshot('control', filename_for_test(test, description))
      diff = Compatriot::ColorDiffer.diff(variable_img_path, control_img_path, self.screenshot_directory + '/')
      variable_image = ChunkyPNG::Image.from_file(variable_img_path)
      Compatriot::ColorDiffer.color_difference_percentage(variable_image, diff)
    end

    def filename_for_test(test, description)
      test_name = test.name.match(/test_[0-9]+_(.*)/)[1]
      class_name = test.class.name
      filename = class_name + '_' + test_name
      filename += '_' + description unless description.empty?
      filename.tr(' ', '_').downcase + '.png'
    end

    def filepath_for_screenshot(type, filename)
      File.expand_path(self.screenshot_directory + '/' + type + '/' + filename)
    end
  end

  Compatriot.configure do |config|
    config.screenshot_directory = './compatriot/screenshots'
  end
end
