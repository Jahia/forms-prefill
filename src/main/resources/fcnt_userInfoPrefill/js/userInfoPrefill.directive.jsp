<%@ page contentType="text/javascript" %>
<%@ taglib prefix="formfactory" uri="http://www.jahia.org/formfactory/functions" %>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>

(function() {
    var userInfoPrefill = function(ffTemplateResolver) {
        return {
            restrict: 'E',
            templateUrl: function(el, attrs) {
                return ffTemplateResolver.resolveTemplatePath('${formfactory:addFormFactoryModulePath('/form-factory-prefills/user-info-prefill', renderContext)}', attrs.viewType);
            },
            link:linkFunc
        };

        function linkFunc(scope, el, attr, ctrl) {
            scope.prefillName = 'user-info-prefill';
        }
    };
    angular
        .module('formFactory')
        .directive('ffUserInfo', ['ffTemplateResolver', userInfoPrefill]);
})();