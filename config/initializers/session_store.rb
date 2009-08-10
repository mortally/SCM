# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_computer-poker-analysis_session',
  :secret      => '713f34013fc4e8fa956beb5ba43164fd501b18a90773e581df80f1f345b7647d1d9a7f448338e935380de6796fdc4c61a12b10ba95a2f70cd228e3316fc24345'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
