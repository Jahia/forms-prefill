<%@ page contentType="text/javascript" %>

(function () {
    'use strict';

    console.log("Processing userInfoPrefill service");

    var userInfoPrefillService = function (ffSRS) {

        this.activate = function() {
            console.log("Activating ..");
            ffSRS.registerService("userInfoPrefillService", this);
        }
    };

    angular.module('formFactory')
            .service('userInfoPrefillService', ["ffServiceRegistryService", userInfoPrefillService]);
})();