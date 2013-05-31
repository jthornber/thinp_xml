When(/^I thinp_xml (.*)$/) do |cmd|
  run_simple(unescape("thinp_xml #{cmd}"), false)
end
