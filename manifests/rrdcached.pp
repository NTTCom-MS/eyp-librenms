class librenms::rrdcached() inherits librenms {
  include ::rrdtool

  include ::rrdtool::rrdcached
}
