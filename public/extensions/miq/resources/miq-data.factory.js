(function() {
  'use strict';

  angular.module('app.resources')
    .factory('MiqData', MiqDataFactory);

  /** @ngInject */
  function MiqDataFactory($resource) {
    var base = '/api/v1/miq/providers/:id/:action';
    var MiqData = $resource(base, {action: '@action', id: '@id'});

    MiqData.deprovision = deprovision;

    return MiqData;

    function deprovision(id, service_id) {
      return MiqData.query({id: id, action: 'deprovision', service_id: service_id}).$promise;
    }
  }
})();
