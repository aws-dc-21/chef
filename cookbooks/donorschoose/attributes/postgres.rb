default['postgresql'] ||= {}
default['postgresql']['password'] ||= {}
default['postgresql']['password']['postgres'] = 'nr628rh7uv6f'

default['postgres']['password'] = 'm9wurarfs4qy'
default['postgres']['users'] = {
    root: {
        password: 'root',
    },
    app: {
        password: 'm9wurarfs4qy',
    }
}