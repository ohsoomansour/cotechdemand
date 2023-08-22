var CommonController = function() {
	var anonymousClass = {
		jobno : null,
		popLayerOpen : function(tmplId) {
			$('.adminPopupDimmLayer').show();
			$('.adminPopupContainer .adminPopupLayerWrap').html($('#'+tmplId).tmpl());
			try {
				$('.adminPopupContainer').css({ top : $(document).scrollTop()});
			}
			catch(ex) {};
			$('.adminPopupContainer').show();
			$('.adminPopupLayerHeader .popBtnCloser').click(function() {
				anonymousClass.popLayerClose();
			});
			
			var _popController = popController(); 
			try {
				eval('_popController.'+tmplId+'()');
			}
			catch(ex) {};
		},
		
		doLoginCheckAlert : function(data) {
			var retCode = 0;
			$.ajax({
			   type: "GET",
			   async : false,
			   url: "/comm/ajax/getSessionAjax",
			   data: data,
			   success: function(response) {
				   try {
					   retCode = response.member.memberSeq;
				   }
				   catch(ex) {
					   anonymousClass.dialog('로그인!', '로그인 후 이용하실 수 있습니다.');
				   };
			   },
			   dataType:"json"
			});	
			return retCode;
		},
		
		popLayerClose : function() {
			$('.adminPopupDimmLayer').hide();
			$('.adminPopupContainer').hide();
		},
		
		dialog : function(title, content) {
			//$('.ui-dialog').remove();
			var dialogId = "dialog_"+new Date().getTime();
		    $($('#dialog_Tmpl').tmpl({
				dialogId : dialogId,
				title : title,
				content : content
			})).dialog({
				resizable: false,
				height:340,
				modal: true,
				buttons: {
					'닫기 ': function() {
		    			$(this).dialog( "close" );
		    			$(this).dialog( "destroy" );
					}
				}
		    });
		    return dialogId;
		},
		
		confirmDialog : function(title, content, retFunction, args) {
			//$('.ui-dialog').remove();
			var dialogId = "dialog_"+new Date().getTime();
			
			
		    $($('#dialog_Tmpl').tmpl({
				dialogId : dialogId,
				title : title,
				content : content
			})).dialog({
				resizable: false,
				height:340,
				modal: true,
				buttons: {
					'확인': function() {
						if (args == undefined) {
							args = "";
						}
						$( '#'+dialogId ).remove();
						try {
							eval(retFunction+"(" + args + ");");
						}
						catch(ex) {
							eval(retFunction+"(args);");
						}
						
					},
					'닫기': function() {
						$(this).dialog( "destroy" );
		    			$( '#'+dialogId ).remove();
					}
				}
		    });
		    return dialogId;
		},
		
		getDate : function(dot) {
			var dt = new Date();
			var mon = (dt.getMonth()+1) < 10 ? '0'+(dt.getMonth()+1) : (dt.getMonth()+1);
			var date = dt.getDate() < 10 ? '0'+dt.getDate() : dt.getDate();
			if (dot == undefined)dot = '.';
			return dt.getFullYear()+dot+mon+dot+date; 
		},
		
		getDateTime : function(dot) {
			var dt = new Date();
			var mon = (dt.getMonth()+1) < 10 ? '0'+(dt.getMonth()+1) : (dt.getMonth()+1);
			var date = dt.getDate() < 10 ? '0'+dt.getDate() : dt.getDate();
			var hour =  dt.getHours();
			var min = dt.getMinutes();
			var sec = dt.getSeconds();
			if (dot == undefined)dot = '.';
			return dt.getFullYear()+dot+mon+dot+date+" "+hour+":"+min+":"+sec; 
		},
		
		calDateTime : function(endDateTime) {
			
			var startStamp = new Date().getTime();
			var endStamp = anonymousClass.calTimeStamp(endDateTime);
			
			//var ndt = new Date(startStamp);
			var time = endStamp - startStamp;
			var second = (time / 1000);
			var rSec = Math.floor((time / 1000) % 60);
			var minute = (second / 60);
			var rMin = Math.floor((second / 60) % 60);
			var hour = minute / 60; 
			var rHour = Math.floor((minute / 60) % 24);
			var day = Math.floor(hour / 24);
			
			var ret = {
					day : day,
					hour : rHour,
					min : rMin < 10 ? '0'+rMin : rMin,
					sec : rSec < 10 ? '0'+rSec : rSec
				};
			return ret;
		},
		
		calTimeStamp : function(str) {
			var str = str.replace(/[^0-9]/ig, ''); 
			var y = str.substring(0,4);
			var m = parseInt(str.substring(4,6), 10)-1;
			var d = str.substring(6,8);
			var h = str.substring(8,10);
			var i = str.substring(10,12);
			var s = str.substring(12,14);
			var dt = new Date(y, m, d, h, i, s);
			return dt.getTime();
		},
		
		printYmd : function(ymd, dot) {
			var ymd = ymd.replace(/[^0-9]/ig, '');
			var y = ymd.substring(0,4);
			var m = ymd.substring(4,6);
			var d = ymd.substring(6,8);
			if (dot == undefined) dot = '.'; 
			return y+ dot+m + dot+d;
		},
		
		commify : function (n) {
			var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
			n += '';                          // 숫자를 문자열로 변환
			while (reg.test(n))
			  n = n.replace(reg, '$1' + ',' + '$2');
			return n;
		},
		orgCate : null,
		
		loadOrgCate : function(obj, items) {
			$.ajax({
				   type: "GET",
				   async : false,
				   url: "/svc/sceval/ajaxCateOrg.do",
				   data: {
				   },
				   success: function(response) {
					   try {
						   var retCode = parseInt(response.status,10);
						   anonymousClass.orgCate = response.ctgrOran;
						   anonymousClass.makeOrgCateCombo(4, null, obj, items);
					   }
					   catch(ex) {
						   _common.dialog('오류!', '조직도 추출 도중 오류 발생.');
					   };
				   },
				   dataType:"json"
				});
		},
		
		makeOrgCateCombo : function (level, pval, obj, items) {
			$('.orgnoSelct').each(function() {
				if (level <= parseInt($(this).attr('id').replace(/[^0-9]/ig, ''), 10)) {
					$(this).remove();
				}
			});
			if (pval != undefined && pval == '_') return false;
			
			$(obj).append(' <select id="orgno'+level+'" class="orgnoSelct" onchange="_common.makeOrgCateCombo('+(level+1)+',this.value, \''+obj+'\');"></select>');
			$(obj+' #orgno'+level).append('<option value="_"> 선택 </option>');
			var cnt  = 0;
			var userVal = "";
			
			if (items != undefined) {
				$.each(items, function(idx) {
					if (this.levels == level) {
						userVal = this.id;
						anonymousClass.jobno = this.jobno;
					}
				});
			}
			
			$.each(anonymousClass.orgCate, function(idx) {
				if (level == parseInt(this.levels, 10)) {
					var sel = '  ';
					if (userVal == this.id) sel = ' selected ';
					if (pval != undefined) {
						if (pval == this.parent) {
							$(obj+' #orgno'+level).append('<option value="'+this.id+'"  '+sel+'>'+ this.text+'</option>');
							cnt++;
						}
					}
					else {
						$(obj+' #orgno'+level).append('<option value="'+this.id+'"  '+sel+'>'+ this.text+'</option>');
						cnt++;
					}
				}
			});
			if (cnt == 0) {
				$(obj+' #orgno'+level).remove();
			}
			if (userVal != "") {
				anonymousClass.makeOrgCateCombo(level+1, userVal, obj, items);
				return false;
			}
			if (pval != undefined && pval != '_')  anonymousClass.getLoadOrgJob(pval, anonymousClass.jobno);
		},
		
		getLoadOrgJob : function(orgno, jobno) {
			$('#board_list_div input[name=orgno]').val(orgno);
			$.ajax({
				   type: "GET",
				   async : false,
				   url: "/svc/sceval/ajaxOrgJob.do",
				   data: {
					   orgno : orgno
				   },
				   success: function(response) {
					   try {
						   var retCode = parseInt(response.status,10);
						   $('select[name=jobno]').empty();
						   $('select[name=jobno]').append('<option value="">직무</option>');
						   if (response.orgJob.length > 0) {
							   $.each(response.orgJob, function(idx) {
								   var sel = "";
								   if (jobno != undefined) {
									   if (jobno == this.jobno) sel = " selected "
								   }
								   
								   $('select[name=jobno]').append('<option value="'+this.jobno+'" '+sel+'>'+this.orgjob_nm+'</option>');
							   });
						   }
						   else {
							   $('select[name=jobno]').append('<option value="">NO DATA</option>');
						   }
					   }
					   catch(ex) {
						   _common.dialog('오류!', '직무정보 추출 도중 오류 발생.');
					   };
				   },
				   dataType:"json"
				});
		}
	};
	return anonymousClass;
};
var _common = CommonController();