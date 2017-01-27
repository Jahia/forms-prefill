<%@ page contentType="text/javascript" %>

    (function () {
        'use strict';

        var geoLocationPrefill = function (contextualData, $q, $http, $window) {

            var dataCache = null;
            var q = null;

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

                if (q !== null) {
                    return q;
                }

                q = $q(function(resolve, reject) {
                    getGeoLocation();

                    function getGeoLocation() {
                        if ($window.navigator.geolocation) {
                            $window.navigator.geolocation.getCurrentPosition(processCoords, geolocationErrorHandler);
                        } else {
                            reject('Geolocation is unavailable.');
                        }
                    }

                    function processCoords(geolocation) {
                        $http({
                            //Entry point implemented in form-factory-core module as an example
                            url: 'https://maps.googleapis.com/maps/api/geocode/json',
                            method: 'GET',
                            params: {
                                latlng: geolocation.coords.latitude + ',' + geolocation.coords.longitude
                            }
                        }).then(function(response) {
                            console.log("Geolocation information", response.data);
                            //Manipulate data as you see fit
                            if (_.isEmpty(response.data.results)){
                                return reject('No results found.');
                            }
                            //Cache data to avoid future requests
                            var location = response.data.results[0];
                            dataCache = {
                                formatted_address: location['formatted_address'],
                                postal_code: null,
                                country: null
                            };
                            //Used to keep track of which properties we have found so we dont have to look for them anymore.
                            var itemsToSearch = {
                                postal_code : true,
                                country: true
                            };
                            for (var i in location['address_components']) {
                                if (!itemsToSearch['postal_code'] && !itemsToSearch['country']) {
                                    break;
                                }
                                if (itemsToSearch['postal_code'] && _.find(location['address_components'][i].types, findProperty('postal_code'))) {
                                    dataCache['postal_code'] = location['address_components'][i]['long_name'];
                                    itemsToSearch['postal_code'] = !itemsToSearch['postal_code'];
                                    continue;
                                }
                                if (itemsToSearch['country'] && _.find(location['address_components'][i].types, findProperty('country'))) {
                                    dataCache['country'] = location['address_components'][i]['long_name'];
                                    itemsToSearch['country'] = !itemsToSearch['country'];
                                    continue;
                                }
                            }
                            resolve(dataCache);
                        }, function(error) {
                            reject(error);
                        });
                    }

                    function findProperty(item) {
                        return function(value) {
                            return value == item;
                        }
                    }
                    function geolocationErrorHandler(error) {
                        console.log('Failed to retrieve location information.');
                        reject(error.message);
                    }
                });
                return q;
            };
        };

        angular.module('formFactory')
            .service('geolocationPrefillService', ['contextualData',
                '$q', '$http', '$window', geoLocationPrefill]);
    })();