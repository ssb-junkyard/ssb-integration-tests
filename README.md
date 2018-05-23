# ssb-integration-tests

integration tests that can check any two sbot implementations are compatible

all tests are driven via the command line interface and the implementations are
running as processes, so these tests should be usable even for other implementations.

## usage

clone this, then run

```
./scripts/install.sh install # install all sbot version >= 10
./test/01_load.sh path_to_test_sbot versions/*/bin
```

currently there is only one test. but it loads deterministic random data into the test sbot,
then reloads it in every other sbot version, and checks that they

## tests

### load

generate messages deterministically, load into sbot instance
read that data back out using `createLogStream, friends.hops, links,` and `latest`
output must match _exactly_

## TODO

* efficient visualization of tests against version

## License

MIT









