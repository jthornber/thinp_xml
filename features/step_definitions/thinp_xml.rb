When(/^I thinp_xml (.*)$/) do |cmd|
  run_simple(unescape("thinp_xml #{cmd}"), false)
end

Then(/^it should pass$/) do
  assert_success(true)
end

Then(/^it should fail$/) do
  assert_success(false)
end

