(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    Forms.fields('environments', {
      type: 'select',
      templateOptions: {
        label: 'Environment',
        options: [
          {label: 'Development', value: 'Development'},
          {label: 'Test', value: 'Test'},
          {label: 'Production', value: 'Production'}
        ]
      }
    });

    /** @ngInject */
    function MiqDataController($scope, MiqData, Toasts) {
      var provider = $scope.formState.provider;
      var action = $scope.options.data.action;

      // Cannot do anything without a provider
      if (angular.isUndefined(provider)) {
        Toasts.warning('No provider set in form state', $scope.options.label);
        return;
      }

      if (!action) {
        Toasts.warning('No action set in field data', $scope.options.label);
        return;
      }

      $scope.to.loading = MiqData[action](provider.id).then(handleResults, handleError);

      function handleResults(data) {
        $scope.to.options = data;
        return data;
      }

      function handleError(response) {
        var error = response.data;

        if (!error.error) {
          error = {
            type: 'Server Error',
            error: 'An unknown automation error has occurred.'
          };
        }

        Toasts.error(error.error, [$scope.to.label, error.type].join('::'));

        return response;
      }
    }
  }
})();
