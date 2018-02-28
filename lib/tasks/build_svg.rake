require 'rexml/document'

desc 'Combine all SVG icons into a single SVG'
task :build_svg do
  icons_dir = Rails.root.join('app', 'assets', 'images', 'icons')

  # rubocop:disable Metrics/LineLength
  svg_content = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<svg width=\"256px\" height=\"256px\" viewBox=\"0 0 256 256\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"
  # rubocop:enable Metrics/LineLength

  Dir.glob("#{icons_dir}/*.svg").each do |file|
    doc = Nokogiri::XML(File.read(file))
    icon_name = doc.css('#Page-1 > g')[0]['id']
    content = doc.css('#Page-1 g').to_s
    # rubocop:disable Metrics/LineLength
    svg_content += "<svg width=\"256px\" height=\"256px\" viewBox=\"0 0 256 256\" id=\"#{icon_name}\">\
  #{content.gsub(/[a-z\-]+=\"[a-zA-Z0-9\-\#]+\"/, '')}\
</svg>"
    # rubocop:enable Metrics/LineLength
  end
  svg_content += '</svg>'

  svg_content = REXML::Document.new(svg_content)
  output = ''
  svg_content.write(output, 2)

  icons_file = Rails.root.join('app', 'assets', 'images', 'icons.svg')
  File.open(icons_file, 'w+') { |file| file.write(output) }
end
