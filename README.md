# rough outline

warning: some commands in these scripts are from my environment, i will fix that later.

- `00*.sh` - shared by master and workers, common code
- `01*.sh` - run on workers, to do with backend onion services
- `02*.sh` - run on master, to do with onionbalance
- other files - general purpose / interactive tools

# filesystem layout

- all this lives in `$HOME/master.d`, on the master
- the `master-push.sh` script clones `master.d` to `worker.d` on the workers
- workers and master alike all use `$HOME/tmp` for local storage
- master also replicates `$HOME/tmp` from workers to `remote.d`
