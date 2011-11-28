require 'erb'

module XProj
  class ResultsPresenter
    def initialize(results_directory)
      @results_directory = results_directory
    end

    def make_index_page(results)
      index_page_file = File.join(@results_directory, "index.html")

      b = binding
      browsers = results.keys
      paths = results[browsers.first].keys

      html = ERB.new <<-EOF
        <html>
          <head>
            <title>Cross browser test results</title>
            <style type='text/css'>
              table, tr, th, td {
                border: 1px solid #aaa;
              }
              img {
                width: 300px;
              }
            </style>
          </head>
          <body>
            <h1>Results</h1>
            <table>
              <tr>
                <th>Path</th>
                <% browsers.each do |browser| %>
                  <th><%= browser %></th>
                <% end %>
              </tr>
              <% paths.each do |path| %>
                <tr>
                  <td>
                    <%= path %>
                  </td>
                  <% browsers.each do |browser| %>
                    <td>
                      <img src="<%= browser %>/<%= results[browser][path] %>" />
                    </td>
                  <% end %>
                </tr>
              <% end %>
            </table>
          </body>
        </html>
      EOF

      File.open(index_page_file, 'w') {|f| f.write(html.result(b)) }
    end
  end
end