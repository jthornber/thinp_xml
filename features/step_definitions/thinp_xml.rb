When(/^I thinp_xml (.*)$/) do |cmd|
  run_simple(sanitize_text("thinp_xml #{cmd}"), false)
end

When(/^I cache_xml (.*)$/) do |cmd|
  run_simple(sanitize_text("cache_xml #{cmd}"), false)
end

When(/^I era_xml (.*)$/) do |cmd|
  run_simple(sanitize_text("era_xml #{cmd}"), false)
end

Then(/^it should pass$/) do
	expect(last_command_started).to be_successfully_executed
end

Then(/^it should fail$/) do
	expect(last_command_started).to_not be_successfully_executed
end

