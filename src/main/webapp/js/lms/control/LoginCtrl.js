var LoginCtrl = {
	
		doLogin : function() {
		if ($.trim($("#userid").val()) == "") {
			alert("아이디를 입력해 주세요.");
			return false;
		}
		if ($.trim($("#userpw").val()) == "") {
			alert("비밀번호를 입력해 주세요.");
			return false;
		}

		var strLoginActionUrl = "./main/loginX.do";
		$.ajax({
			url : strLoginActionUrl,
			data : {
				"userid" : $("#userid").val(),
				"userpw" : $("#userpw").val(),
				"keep" : ($("#keep").is(":checked") ? "Y" : "N")
			},
			dataType : "json",
			success : function(resp) {
				if (resp.result_code == "0") {
					if ($("#idsave").is(":checked")) {
						_lsCtrl.setProperty("SAVEID", $("#userid").val().toLowerCase());
					}
					else {
						_lsCtrl.setProperty("SAVEID", "");
					}
					var gourl = $.trim($("#gourl").val());
					location.href = gourl;
				}
				else {
					alert(resp.result_mesg);
				}
			},
			error : function(result) {
				alert("로그인을 다시해 주세요.");
			}
		});
		return false;
	},
};
