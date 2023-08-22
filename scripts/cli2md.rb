# frozen_string_literal: true

require "cgi"

incode = false
first_param = false

# read from stdin or files in the args
ARGF.each_with_index do |line, line_num|
  # Headings
  if /^(\w*):/ =~ line
    puts "### #{Regexp.last_match(1)}"
  # Initial usage command
  elsif line_num == 2
    puts "`#{line.strip}`"
  # Code sections
  elsif /\s{3}\$/ =~ line
    # Break code lines that end in \
    incode = true if line[-2] == "\\"
    puts " #{line}"
  # If previous line ends in \ indent to code block
  elsif incode
    incode = false
    puts "  #{line}"
  # Lists of parameters
  #  --config value             Path to a configuration file [$BUILDKITE_AGENT_CONFIG]
  elsif /\s{3}(-{2}[a-z0-9\- ]*)([A-Z].*)$/ =~ line
    if first_param == false
      puts "<!-- vale off -->\n\n<table class=\"Docs__attribute__table\">"
      first_param = true
    end
    command_and_value = Regexp.last_match(1).rstrip
    command = command_and_value.split[0][2..]
    value = command_and_value.split[1]
    desc  = Regexp.last_match(2)

    # Extract $BUILDKITE_* env and remove from desc
    /(\$BUILDKITE[A-Z0-9_]*)/ =~ desc
    env_var = Regexp.last_match(1)
    desc.gsub!(/(\s\[\$BUILDKITE[A-Z0-9_]*\])/, "")

    # Wrap https://agent.buildkite.com/v3 in code
    desc.gsub!("https://agent.buildkite.com/v3", "<code>https://agent.buildkite.com/v3</code>")

    # Replace all prime symbols with backticks. We use prime symbols instead of backticks in CLI
    # helptext for... reasons.
    # See: https://github.com/buildkite/agent/blob/main/clicommand/prime-signs.md
    desc.tr!("′", "`")
    desc.gsub!(Dir.home, "$HOME")
    print "<tr id=\"#{command}\">"
    print "<th><code>--#{command} #{value}</code> <a class=\"Docs__attribute__link\" href=\"##{command}\">#</a></th>"
    print "<td><p>#{desc}"
    print "<br /><strong>Environment variable</strong>: <code>#{env_var}</code>" unless env_var.nil? || env_var.empty?
    print "</p></td>"
    print "</tr>"
    puts
  else
    if first_param
      puts "</table>\n\n<!-- vale on -->\n"
      first_param = false
      next
    end
    puts CGI.escapeHTML(line.lstrip)
  end
end
