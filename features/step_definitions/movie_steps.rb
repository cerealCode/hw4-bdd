
Given /the following movies exist/ do |movies_table|
  @row = 0
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    @row += 1
  end
end


Then /I should see "(.*)" before "(.*)"$/ do |e1, e2|
 expect page.body =~ /#{e1}.*#{e2}/m 
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)$/ do |uncheck, rating_list|
  rating_list.delete!("\"")
  if uncheck.nil?
    rating_list.split(',').each do |field|
      check("ratings["+field.strip+"]")
    end
  else
    rating_list.split(',').each do |field|
      uncheck("ratings["+field.strip+"]")
    end
  end
end

And (/^I press 'ratings_submit'$/) do
  click_button 'ratings_submit'
end

Then(/^I should see:$/) do |table|
  page.should have_content(table)
end

And(/^I should not see:$/) do |table|
  page should_have_no_content(table)
end 

Then /I should see all of the movies/ do
  page.should have_css("table#movies tbody tr",:count => @row)
end

Then /I should not see all of the movies/ do
  page.should have_no_css("table#movies tbody tr")
end