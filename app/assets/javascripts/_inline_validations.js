$(function() {
	clientSideValidations.callbacks.element.after = function(element, eventData) {
		// element is the input element (text field). The text field is wrapped by 
		// the error so the parent is the error_wrapper. The label is a child of 
		// the wrapper and the html of the label is the actual error message
		// console.log(eventData);
		// console.log(element);
		var elementContainer = element.parents('#field');
		var errorLabel = element.parent().find('label');
		var errorMsg = errorLabel.html();
		errorLabel.hide();
		var existingError = elementContainer.find('#validation-error');
		if(!errorMsg || errorMsg == null) {
			existingError.remove();
		} else if(existingError && existingError.length > 0) {
			existingError.html(errorMsg);
		} else {
			elementContainer.append('<div id="validation-error">' + errorMsg + '</div>');
		}
	}
});