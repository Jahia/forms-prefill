<%@ page contentType="text/javascript" %>
<%@ taglib prefix="formfactory" uri="http://www.jahia.org/formfactory/functions" %>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>

(function() {
    var chuckNorrisPrefill = function(ffTemplateResolver) {
        return {
            restrict: 'E',
            templateUrl: function(el, attrs) {
                return ffTemplateResolver.resolveTemplatePath('${formfactory:addFormFactoryModulePath('/form-factory-prefills/chuck-norris-prefill', renderContext)}', attrs.viewType);
            },
            link:linkFunc
        };

        function linkFunc(scope, el, attr, ctrl) {
            scope.prefillName = 'chuck-norris-prefill';
        }
    };
    angular
        .module('formFactory')
        .directive('ffChuckNorris', ['ffTemplateResolver', chuckNorrisPrefill]);
})();