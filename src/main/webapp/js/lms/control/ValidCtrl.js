
/* validator */
function ValidatorController () {
	var innerClass = {
		_common : null,
		eventListner : function(obj) {
			$(obj).find('input[type=text]').each(function(){
				if ($(this).attr('debug') == 'false') return;
				
				if ($(this).hasClass('num')) {
					$(this).keyup(function() {
						if(/[^0-9]/.test($(this).val())) {
							$(this).val($(this).val().replace(/[^0-9]/ig, ''));
						}
					});	
				}
			});
		},
		doValidator : function(obj) {
			if (!innerClass._common) {
				if (_common != undefined) {
					innerClass._common = _common;
				}
				else {
					innerClass._common = CommonController();
				}
			}
			var valid = true;
			
			if ($.type($(obj)) == 'object' && $(obj).html() != '' && $(obj).html() != undefined) {
				valid = innerClass.doValidatorInput(obj);
				if (valid) valid = innerClass.doValidatorTextArea(obj);
				if (valid) valid = innerClass.doValidatorSelection(obj);
				
			}
			else {
				if ($.type($('#'+obj)) == 'object') {
					valid = innerClass.doValidatorInput('#'+obj);
					if (valid) valid = innerClass.doValidatorTextArea('#'+obj);
					if (valid) valid = innerClass.doValidatorSelection('#'+obj);
				}
			}
			return valid;
		},
		
		doValidatorInput : function(obj) {
			var valid = true;
			//text check
			
			$(obj).find('input[type=text]').each(function(){
				if (!valid) return;
				if ($(this).attr('debug') == 'false') return;
				if ($.trim($(this).val()) == '') {
					valid = false;
					innerClass._common.dialog('오류!', $(this).attr('title')+'은(는) 필수 항목입니다.');
				}
			});
			
			if (!valid) return valid;
			
			
			//radio check
			var oldRadioChkName = '';
			var arrRadioChkName = [];
			$(obj).find('input[type=radio]').each(function(){
				if ($(this).attr('name') != oldRadioChkName) {
					if ($(this).attr('debug') == 'false') return;
					oldRadioChkName = $(this).attr('name');
					arrRadioChkName.push({name : oldRadioChkName});					
				}
			});
			$.each(arrRadioChkName, function(idx) {
				if (!valid) return;
				if ($(obj).find('input[name='+this.name+']:checked').length ==0) {
					valid = false;
					innerClass._common.dialog('오류!', $(obj).find('input[name='+this.name+']').eq(0).attr('title')+'은(는) 필수 체크 항목입니다.');
				}
			});
			
			
			
			//checkbox check
			
			if (!valid) return valid;
			var oldChkName = '';
			var arrChkName = [];
			$(obj).find('input[type=checkbox]').each(function(){
				if ($(this).attr('class') != oldChkName) {
					if ($(this).attr('debug') == 'false') return;
					oldChkName = $(this).attr('class');
					arrChkName.push(oldChkName);					
				}
			});
			$.each(arrChkName, function() {
				if (!valid) return;
				if ($(obj).find('.'+this+':checked').length ==0) {
					valid = false;
					innerClass._common.dialog('오류!', $(obj).find('input[name='+this+']').eq(0).attr('title')+'은(는) 필수 체크 항목입니다.');
				}
			});
			
			return valid;
		},
		
		doValidatorSelection : function(obj) {
			var valid = true;
			$(obj).find('select').each(function(){
				if (!valid) return;
				if ($(this).attr('debug') == 'false') return;
				if ($.trim($(this).val()) == '') {
					valid = false;
					innerClass._common.dialog('오류!', $(this).attr('title')+'은(는) 필수 항목입니다.');
				}
			});
			return valid;
		},
		
		doValidatorTextArea : function(obj) {
			var valid = true;
			$(obj).find('textarea').each(function(){
				if (!valid) return;
				if ($(this).attr('debug') == 'false') return;
				if ($.trim($(this).val()) == '') {
					valid = false;
					innerClass._common.dialog('오류!', $(this).attr('title')+'은(는) 필수 항목입니다.');
				}
			});
			return valid;
		}
	}
	return innerClass;
}