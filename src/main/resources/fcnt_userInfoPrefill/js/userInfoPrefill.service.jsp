<%@ page contentType="text/javascript" %>

(function () {
    'use strict';

    var userInfoPrefillService = function (contextualData, $q, $http) {

        var dataCache = null;

        /**
         * MUST IMPLEMENT
         *
         * Gets data for prefill which must be an object:  { key: value, ... }
         * @returns {Promise}
         */
        this.getData = function() {
            if (dataCache !== null) {
                return $q(function(resolve, reject) {
                    resolve(dataCache);
                });
            }
            return $q(function(resolve, reject) {
                $http({
                    //Entry point implemented in form-factory-core module as an example
                    url: contextualData.context + '/modules/formfactory/live/userinfo/' + contextualData.locale,
                    method: 'GET'
                }).then(function(data) {
                    console.log("User info prefill service", data);
                    //Manipulate data as you see fit

                    //Cache data to avoid future requests
                    dataCache = data.data;
                    resolve(dataCache);
                }, function(error) {
                    reject(error);
                });
            });
        }
    };

    angular.module('formFactory')
            .service('userInfoPrefillService', ["contextualData",
                "$q", "$http", userInfoPrefillService]);
})();