# Customizations
This repository was forked to be modified for use on a Deis cluster. We also removed the LDAP configs to allow us to configure users directly in the app. 

When initially running this on a deis cluster you will need to init the database by running:
`deis run /entrypoint.sh deploy`
`deis run /entrypoint.sh demosteup`

# Quickstart

Note that this is not a production setup, but it is very close. Just change the
configuration a bit to you liking.

    docker-compose up
    # when it is up, open a new terminal and:
    docker run --rm --link ratticdocker_postgres_1:postgres ratticdocker_rattic deploy
    docker run --rm --link ratticdocker_postgres_1:postgres ratticdocker_rattic demosetup

# Configuration

Look at the env vars available in the `Dockerfile` and `entrypoint.sh`.
