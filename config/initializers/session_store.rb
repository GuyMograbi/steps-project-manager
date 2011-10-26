# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
#~!~ guy - use the db instead
ActionController::Base.session = {

  :key         => '_project_manager_session',
  :secret      => 'dd39b12cdb7368ffd77c61191e5c2523be872b34a018d3693519a893e82011d7b114f53313d700ef0d73d47192da1a956aa1c859e99ce6d24a19d91d454ae5d3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
