{
  services.nfs.server.exports = ''
    /storage/data    *(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    /storage/media   *(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    /storage/backups *(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
  '';
}
