# Notes

## Random

- Make responding to invitations easy. Make finding / sending group descriptions easy.

## Other Packages

### Cloud-based

- http://www.groupvitals.com
Very nice, new package. Many of the same feature set as outlined for *theGatherings.*
Is working on integration with other packages / systems. Fee-based.

- http://groupsinteractive.com
Basic hosted package. Inexpensive ($250 / year). Limited feature set.

- http://www.acstechnologies.com/products/the-city
Limited and expensive.

- https://churchgroupshq.com
Moderate feature set. Expensive.

- http://www.fellowshipone.com
Full package with some features for groups. Pricing unpublished, but likely expensive.

- https://www.churchteams.com/ct/
Full package with some features for groups. Provides some health assessment tools. Standard
pricing model. Richer set of small group features compared to FellowshipOne.


### Old School

- http://workingchurch.com/Cell-Small-Groups.html

- http://www.excellerate.com/products/church-management-software/cms-features/f-group/
They offer a cloud solution that is horribly expensive (e.g., 100 simultaneous connections is
nearly $5k).

## Application Model

- Review React.js http://facebook.github.io/react/index.html
- Review Flux https://facebook.github.io/flux/docs/overview.html

## Reports and Graphing

- http://www.sitepoint.com/creating-simple-line-bar-charts-using-d3-js/
- http://d3js.org
- https://www.dashingd3js.com/svg-paths-and-d3js
- https://www.dashingd3js.com/table-of-contents

## Comments

- http://web.livefyre.com/comments/
- https://publishers.disqus.com/engage
- http://www.intensedebate.com/

## Setup

### Containers

- See https://labs.ctl.io/developing-rails-apps-in-container-with-docker-compose/

### Bower

- http://dotwell.io/taking-advantage-of-bower-in-your-rails-4-app/

### Devise and OAuth

- https://github.com/doorkeeper-gem/doorkeeper/wiki
- https://www.youtube.com/watch?v=6tQTwmIgclE (Authorization in an SOA Environment)
- https://www.youtube.com/watch?v=L1B_HpCW8bs (Service Oriented Authentication)
- http://www.thoughtsonrails.com/devise-and-omniauth/ for Devise and Omniauth
- https://github.com/plataformatec/devise
- https://www.digitalocean.com/community/tutorials/how-to-configure-devise-and-omniauth-for-your-rails-application
- http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
- http://devise.plataformatec.com.br
- https://github.com/intridea/omniauth/wiki
- http://ryanwinchester.ca/post/stop-forcing-your-arbitrary-password-rules-on-me on Passwords
- https://www.youtube.com/watch?v=c1ikzPLUPFA
- https://www.youtube.com/watch?v=6tQTwmIgclE&list=PLqyB7G2fnm27V7an_KImYA1eQOORb57Ur
- https://www.youtube.com/watch?v=L1B_HpCW8bs&list=PLqyB7G2fnm27V7an_KImYA1eQOORb57Ur&index=2
- https://www.youtube.com/watch?v=hAA_JAprdkE&list=PLqyB7G2fnm27V7an_KImYA1eQOORb57Ur&index=7
- https://www.youtube.com/watch?v=13SV7MjJugo&list=PLqyB7G2fnm27V7an_KImYA1eQOORb57Ur&index=6

===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

       config.assets.initialize_on_precompile = false

     On config/application.rb forcing your application to not access the DB
     or load models when precompiling your assets.

  5. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================

## Questions / Thoughts

- Members are only allowed to see details of the Gatherings to which they belong,
including the personal detail of other Members. Community detail is available to all Members,
regardless of Community affiliation. How should we ensure this visibility efficiently?
Essentially, Members request Member information within a context; that is, they request details
as a Member of the Gathering.

- Sanitize all data, allow limited HTML in descriptions

- Have Members revalidate their state (flag the Member record, drive through revalidation at next
use?) every six or twelve months to ensure data remains sane.
