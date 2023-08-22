var uploadSrc = (function(window, document, $){
    // values
    var fmstSeq = 0;
    var totalSize = 0;
    var uploaderId = null;
    var uploader = null;
    var no = 1;
    var totalStat = 0;
    var totalCnt = 0;
    var countFile = 0;
    var doneCnt = 0;
    var sucCnt = 0;
    var failCnt = 0;
    var types = [{text: '일반', value: 'N'}];
    var fileList = {};
    var rowTmpl = '<tr id="{{id}}"><td>{{no}}</td><td>{{type}}</td><td>{{name}}</td><td>{{size}}</td><td>{{buttons}}</td></tr>';
    var rowBtnTmpl = '<button type="button" onclick="uploadSrc.cancelFile(\'{{id}}\')" class="btn_step" title="삭제">삭제</button>';
    var rowDelBtnTmpl = '<button type="button" onclick="uploadSrc.deleteFile(\'{{fileId}}\')" class="btn_step" title="삭제" >삭제</button>';
    var cancelDelBtnTmpl = '<button type="button" onclick="uploadSrc.cancelDel(\'{{fileId}}\')" class="btn_step" title="삭제취소" >삭제취소</button>';
    var cancelModBtnTmpl = '<button type="button" onclick="uploadSrc.cancelMod(\'{{fileId}}\', \'{{orgValue}}\')" class="btn_step" title="수정취소" >수정취소</button>';
    var fileEmptyTmpl = '<tr class="file-empty"><td colspan="5">등록된 파일이 없습니다.</td></tr>';
    var dimmerTmpl = '<div class="uploader-dimmer"><div class="inner-area"><h3 class="uploader-title">파일업로드</h3><div class="inner-btns btn_close"><button type="button" onclick="uploadSrc.dimmerClose();"><span class="icon ico_close"></span></button></div></div></div>';
    var statBarTmpl = '<div class="stat-bar"><div class="stat"><div></div>';
    var totalStatBarTmpl = '<div class="stat-bar"><div class="stat" id="total-stat"><div>';
    var linkToList = '<div class="wrap_btn _center" style="padding-top:10px;"><a href="#" onclick="goList();"style="background: darkcyan;"  class="btn_appl" id="fin-upload" title="확인" >확인</a></div>';

    var getUploaderTmpl = function() {
        var tmpl = '';

        tmpl += '<div id="file-uploader" class="file-uploader-queue">';

        tmpl += '	<div class="file-uploader-btns" style="margin-bottom:10px">';
        tmpl += '<span  id=\"size\"> 전체파일 : 00건 , 전체사이즈 : 00KB</span>'
//        tmpl += '		<button type="button" onclick="uploadSrc.startUpload();">업로드 시작</button>';
//        tmpl += '		<button type="button" onclick="uploadSrc.resetUploader();">전체삭제</button>';
        tmpl += '	</div>';
        tmpl += '	';
        tmpl += '	<div class="tbl_comm tbl_public" style="margin:0px">';
        tmpl += '	<table class="file-list-table tbl">';
        tmpl += '	<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">첨부파일</caption>';
        tmpl += '		<colgroup>';
        tmpl += '			<col class="col1"><col class="col2"><col class="col3"><col class="col4"><col class="col5">';
        tmpl += '		</colgroup>';
        tmpl += '		<thead>';
        tmpl += '			<tr>';
        tmpl += '				<th scope="col">번호</th>';
        tmpl += '				<th scope="col">문서구분</th>';
        tmpl += '				<th scope="col">파일명</th>';
        tmpl += '				<th scope="col">사이즈</th>';
        tmpl += '				<th scope="col"></th>';
        tmpl += '			</tr>';
        tmpl += '		</thead>';
        tmpl += '		<tbody>';
        tmpl += '			<tr class="file-empty">';
        tmpl += '				<td colspan="5">등록된 파일이 없습니다.</td>';
        tmpl += '			</tr>';
        tmpl += '			<tr id="add-button-row" class="add-file-row">';
        tmpl += '				<td colspan="5">';
        tmpl += '					<div class="file-up-btn">';
        tmpl += '						<input class="add-input" id="add-file" name="addFile" type="file" title="Click to add Files" style="display:none;"/>';
        tmpl += '						<button type="button" class="btn_step" title="파일선택" onclick="$(\'#add-file\').click();">파일선택</button>';
        tmpl += '					</div>';
        tmpl += '				</td>';
        tmpl += '			</tr>';
        tmpl += '		</tbody>';
        tmpl += '		<tfoot></tfoot>';
        tmpl += '	</table>';
        tmpl += '</div>';
       
      
        
        
        return tmpl;
    }

    //functions
    var create = function(targetEl, options){
        options = options || {};
        var defaults = {
            queue: true,
            auto: false,
            dnd: true,
            multiple: true,
            method: 'POST',
            extraData: function(id){
        		var tr = $('#' + id);
        		        		
        		return {
        			topic: 'editor',
        			fmstSeq: uploadSrc.getMstSeq(),
        			fType: tr.find('select').val(),
        		};
        	},
            headers: {},
            dataType: 'json',
            fieldName: 'file',
            maxFileSize: 0,
            allowedTypes: '*',
            extFilter: null,
            callback: function(){},
        };

        for (var prop in defaults)  {
            options[prop] = typeof options[prop] !== 'undefined' ? options[prop] : defaults[prop];
        }

        // target에 업로더 html 추가
        targetEl.append(getUploaderTmpl());

        // 옵션에 타입 배열이 있을 때 
        if(Array.isArray(options.types)){
            types = options.types;
        }

        // 파일 리스트가 있다면 세팅
        if(options.fmstSeq != 0){
            fmstSeq = options.fmstSeq;
            
            $.ajax({
				url : "/file/list.do",
				type : "POST",
				data : 'fmst_seq=' + fmstSeq,
				dataType : "json",
				success : function(resp) {
					var list = resp.list;
					
					if(list == undefined){
						return;
					}
					
					var arrFile = [];
					$.each(list, function(index, item){
						arrFile.push(
							{
								fileId: item.fslv_seq,
		                        type: item.f_type,
		                        name: item.f_org_nm,
		                        size: item.f_size,
							}
						);
					
					});
					
					setFileList(arrFile);
					
				},
				error : function(result) {
					alert('통신 오류');
				}
			});
        }

        // 업로더 생성
        init('#file-uploader', '/file/upload.do', options);
    }

    var init = function(id, url, options){
        $(id).dmUploader({
            url: url,
            queue: options.queue,
            auto: options.auto,
            dnd: options.dnd,
            multiple: options.multiple,
            method: options.method,
            extraData: options.extraData,
            headers: options.headers,
            dataType: options.dataType,
            fieldName: options.fieldName,
            maxFileSize: options.maxFileSize,
            allowedTypes: options.allowedTypes,
            extFilter: options.extFilter,
            onInit: function(){
                uploaderId = id;
                uploader = this;
            },
            onDragEnter: function(){
                $(this).addClass('hover-zone');
            },
            onDragLeave: function(){
                $(this).removeClass('hover-zone');
            },
            onNewFile: function(id, file){

                if(!isNewFile(file)){
                    alert('이미 추가된 파일입니다.');
                }else{
                    fileList[id] = file;
                    addRow(id, file.name, file.size);
                }

            },
            onUploadProgress: function(id, percent){
                setProgress(id, percent);
            },
            onUploadError: function(id, xhr, status, err){
                finUploadFile(id, '실패');
                failCnt += 1;
            },
            onUploadSuccess: function(id, data){
            	// data에 마스터 아이디가 있다면 세팅
            	if(data.fmstSeq != undefined){
            		fmstSeq = data.fmstSeq;
            	}            	
            
                finUploadFile(id, '완료');
                sucCnt += 1;
            },
            onComplete: function(){
                //alert('총 ' + doneCnt + '건의 파일이 업로드 되었습니다.(성공:'+ sucCnt +'건 , 실패 : '+ failCnt +'건)' );
                //dimmerClose();
                
                // 전체 퍼센트 수정
                $('.uploader-dimmer .inner-area #total-stat').css({width: '100%'});
                
                //wa에서 레이어 두개로인한 에러로 추후 삭제예정
                $('.uploader-dimmer').remove();
                
                // 콜백실행
            	options.callback(fmstSeq);
                
            },
            onFileTypeError: function(file){
                // 파일 제한 타입 에러
                alert('허용되지 않는 타입의 파일입니다.');
            },
            onFileSizeError: function(file){
                // 파일 제한 사이즈 에러
                alert('최대 파일 사이즈를 초과했습니다.');
            },
            onFileExtError: function(file){
                // 파일 확장자 제한 에러
                alert('허용되지 않는 타입의 파일입니다.');
            },
        });
    }
    
    

    var setFileList = function(optFileList){
    	var countFile = 0;
        $.each(optFileList, function(index, item){
        	totalSize+=parseInt(item.size);
        	countFile +=1;
            addFileRow(item);
        });
        $('.file-uploader-btns span').html("전체파일  : &nbsp"+countFile+" 건  &nbsp&nbsp전체 사이즈 : "+sizeConv(totalSize));

    }

    var isNewFile = function(file){
        var result = true;

        $.each(fileList,  function(key, item){
            if(item.name === file.name){
                result = false;
                return false;
            }
        });

        return result;
    }

    var makeTypeSelector = function(objType, onChageFunc){
        var result = '';
        if(onChageFunc != undefined){
            result = '<label><select onchange="'+onChageFunc+'"><option value="">선택</option>';
        }else{
            result = '<label><select><option value="">선택</option>';
        }
        

        $.each(types, function(index, item){
            result += '<option value="'+ item.value + '" ';

            if(objType != undefined){
                if(objType === item.value){
                    result += 'selected';
                }
            }
            

            result += ' >'+ item.text +'</option>';
        });

        result += '</select></label>';

        return result;
    }

    var cancelMod = function(fileId, orgValue){
        var tr = $('#' + fileId);
        tr.find('select').val(orgValue);

        tr.removeClass('modify-uploaded-file');

        var delBtn = rowDelBtnTmpl.replace(/{{fileId}}/gi, fileId);

        // 삭제 버튼 생성
        tr.find('td').eq(4)
        .empty()
        .append(delBtn);
    }

    var handleChangeType = function(target, orgVal){
        var tr = $(target).closest('tr');

        // 최초 수정 시에만 적용
        if(!tr.hasClass('modify-uploaded-file')){

            var btn = cancelModBtnTmpl.replace(/{{fileId}}/gi, tr.attr('id'))
                                    .replace(/{{orgValue}}/gi, orgVal);

            tr.addClass('modify-uploaded-file');
            tr.find('td').eq(4).empty().append(btn);

        }
        
    }

    var addFileRow = function(optFile){
        var buttons = rowDelBtnTmpl.replace(/{{fileId}}/gi, optFile.fileId);

        var typeSelector = makeTypeSelector(optFile.type, 'uploadSrc.handleChangeType(this, \''+ optFile.type + '\')');

		var downUrl = '/file/download.do?fmst_seq='+ fmstSeq +'&fslv_seq='+ optFile.fileId;		
		var name = '<a href="'+ downUrl +'" target="_blank">' + optFile.name + '</a>';

        var newRow = rowTmpl.replace(/{{id}}/gi, optFile.fileId)
        .replace(/{{no}}/gi, no)        
        .replace(/{{type}}/gi, typeSelector)
        .replace(/{{name}}/gi, name)
        .replace(/{{size}}/gi, sizeConv(optFile.size))
        .replace(/{{buttons}}/gi, buttons);

        // 이미 등록 된 파일 표시
        newRow = $(newRow).addClass('uploaded-file');

        // 리스트 있는지 체크 
        if($('#file-uploader .file-list-table .file-empty').length > 0){
            $('#file-uploader .file-list-table .file-empty').remove();
        }

        $('#file-uploader .file-list-table #add-button-row').before(newRow);

        // 인덱스 증감
        no += 1;
        
    }

    var addRow = function(id, name, size){
    	console.log("여기2?")
        var buttons = rowBtnTmpl.replace(/{{id}}/gi, id);

        var typeSelector = makeTypeSelector();

        var newRow = rowTmpl.replace(/{{id}}/gi, id)
        .replace(/{{no}}/gi, no)        
        .replace(/{{type}}/gi, typeSelector)
        .replace(/{{name}}/gi, name)
        .replace(/{{size}}/gi, sizeConv(size))
        .replace(/{{buttons}}/gi, buttons);

        // 리스트 있는지 체크 
        if($('#file-uploader .file-list-table .file-empty').length > 0){
            $('#file-uploader .file-list-table .file-empty').remove();
        }

        $('#file-uploader .file-list-table #add-button-row').before(newRow);
        countFile = no;
    	setTimeout(function(){
    		 $('#'+id).children().find('select').focus();
       	}, 500);
       
        // 인덱스 증감
        totalSize += size;
        $('.file-uploader-btns span').html("전체파일  : &nbsp"+countFile+" 건  &nbsp&nbsp전체 사이즈 : "+sizeConv(totalSize));
        no += 1;
        
    };

    var addFileEmptyRow = function() {
        $('#file-uploader .file-list-table #add-button-row').before(fileEmptyTmpl);
    }

    var resetFileRows = function() {
        $('#file-uploader .file-list-table tbody tr:not(#add-button-row)').remove();

        addFileEmptyRow();
    }

    var cancelDel = function(fileId){
        var target = $('#' + fileId);
        var delBtn = rowDelBtnTmpl.replace(/{{fileId}}/gi, fileId);
        // 파일 클래스에 삭제 표시 제거
        target.removeClass('delete-uploaded-file');

        // 문서구분 활성화
        target.find('td').eq(1)
        .find('select')
        .attr('disabled', false);

        // 삭제 버튼 생성
        target.find('td').eq(4)
        .empty()
        .append(delBtn);
    }

    var deleteFile = function(fileId){
        var target = $('#' + fileId);
        var cancelBtn = cancelDelBtnTmpl.replace(/{{fileId}}/gi, fileId);
        // 파일 클래스에 삭제 표시 
        target.addClass('delete-uploaded-file');

        // 문서구분 비활성화
        target.find('td').eq(1)
        .find('select')
        .attr('disabled', true);

        // 삭제 취소 버튼 생성
        target.find('td').eq(4)
        .empty()
        .append(cancelBtn);
    };

    var cancelFile = function(fileId){
        uploader.dmUploader('cancel', fileId);
        
        // 리스트 테이블에서 삭제
        $('#file-uploader  #'+fileId).remove();

        // 파일 리스트에서 삭제
        delete fileList[fileId];


        // 인덱스 감소
        no -= 1;
        //totalSize = totalSize-size;
        $('.file-uploader-btns span').html("전체파일  : &nbsp"+no+" 건  &nbsp&nbsp전체 사이즈 : "+sizeConv(totalSize));
        if($.isEmptyObject(fileList)){
            // 등록된 파일이 없을 때 empty row 추가 
            addFileEmptyRow();
        }
    }

    var finUploadFile = function(id, text){
        var targetSelector = '.uploader-dimmer .inner-area #'+ id +' td:nth-child(5)';

        $(targetSelector).empty().text(text);
        setTimeout(function(){
        	//$('#upload').focus();
        	//console.log("포커싱됫나",targetSelector)
       	}, 500);
    }

    var setProgress = function(id, percent){
        var targetSelector = '.uploader-dimmer .inner-area #'+ id +' td:nth-child(5)'

        $(targetSelector).find('.stat').css({width: percent + '%'});
        
		setTotalProgress(percent);        
    }
    
    var setTotalProgress = function(eachPercent){
    
    	totalStat += (eachPercent / (100 * totalCnt)) * 100;

        // 완료됐다면 완료카운트 증가
        if(eachPercent === 100){
            doneCnt += 1;
        }

        // 모두 완료라면 강제 100
        if(doneCnt === totalCnt){
            totalStat = 100;
        }

        $('.uploader-dimmer .inner-area #total-stat').css({width: totalStat + '%'});
    	
    }

    var getRequiredType = function(){
        var result = [];

        $.each(types, function(index, item){
            if(item.isRequired){
                result.push(item.text);
            }
        });

        return result;
    };

    var checkType = function(){
        var result = true;
        if(totalSize > 10485760){
    		alert("첨부 용량이 너무 큽니다. 용량제한은 10MB입니다.");
    		result = false;
    		return false;
    	}
        var trs = $('.file-uploader-queue .file-list-table tbody tr:not(".add-file-row")');

        var requiredTypes = getRequiredType();

        $.each(trs, function(index, item){
            var selector = $(item).find('select');
            var selectedTypeText = selector.find('option:selected').text();
            var selectedType = selector.find('option:selected').val();
            if(selectedType === ''){
                alert('문서구분을 선택하세요');
                selector.focus();

                result = false;
                return false;
            }

            //존재할 시 필수문서 배열에서 제거 
            if(requiredTypes.indexOf(selectedTypeText) > -1){
                requiredTypes.splice(requiredTypes.indexOf(selectedTypeText), 1);
            }
            
        });

        /*if(result){
            if(requiredTypes.length > 0) {
                alert(requiredTypes.join(',') + ' 를 등록한 후 다시 시도해주세요.(필수제출서류)');
                result = false;
            }
        }*/
        

        return result;
    }
    
    var beforeUploaded = function(clone, callback){
    	var list = $(clone).find('table tbody tr');
    	
    	$.each(list, function(index, item){
    		if(!$(item).hasClass('uploaded-file')){
    			// 신규파일이 시작되면 종료
                return false;
            }else if($(item).hasClass('delete-uploaded-file')){
            	// 삭제 파일일 경우
                doDeleteFile(item);
            }else if($(item).hasClass('modify-uploaded-file')){
            	// 수정 파일일 경우
                doModifyFile(item);
            }
    	});
    	    	
    	callback();
    }
    
    var doModifyFile = function(tr){
    	var fslvSeq = tr.id;
    	var f_type = $('#' + fslvSeq).find('select').val();    
    
    	$.ajax({
			url : "/file/modify.do",
			type : "POST",
			data : 'fmst_seq=' + fmstSeq + '&fslv_seq=' + fslvSeq + '&f_type=' + f_type,
			dataType : "json",
			success : function(resp) {
				
				if(resp.updateCnt > 0){
					finUploadFile(fslvSeq, '완료');
				}else{
					finUploadFile(fslvSeq, '실패');
				}
				
				setTotalProgress(100);
			},
			error : function(result) {
				finUploadFile(fslvSeq, '실패');
			}
		});
    }
    
    var doDeleteFile = function(tr){
    	var fslvSeq = tr.id;
    
    	$.ajax({
			url : "/file/delete.do",
			type : "POST",
			data : 'fmst_seq=' + fmstSeq + '&fslv_seq=' + fslvSeq,
			dataType : "json",
			success : function(resp) {
				
				if(resp.updateCnt > 0){
					finUploadFile(fslvSeq, '완료');
				}else{
					finUploadFile(fslvSeq, '실패');
				}
				
				setTotalProgress(100);
			},
			error : function(result) {
				finUploadFile(fslvSeq, '실패');
			}
		});
    }

    var startUpload = function(){
        /*if(!hasFiles()){
            alert('변경된 내용이 없습니다.');
            return 0;
        }*/

        // 필수파일 체크
        if(!checkType()){
            return;
        }

        // dimmer 내에 업로드 상태 ui 세팅
        showDimmer(true);

        var clone = setUplodingClone();

        $('.uploader-dimmer .inner-area').append(clone);
        
        
        beforeUploaded(clone, function(){
        	uploader.dmUploader('start');
        });

        
    }

    var setUplodingClone = function() {
        var options = $('.file-uploader-queue .file-list-table tbody tr:not(".add-file-row") option:selected');


        var clone = uploader.clone(true);

        clone.find('.file-uploader-btns').remove();
        clone.find('#add-button-row').remove();
        clone.find('table tbody tr td:nth-child(5)')
        .empty()
        .append(statBarTmpl);

        clone.find('table tbody tr td:nth-child(2)').each(function(index, item){
            $(item).empty().append($(options[index]).text());
        });

        // 변경이 없는 기존파일 제거
        clone.find('.uploaded-file:not(.delete-uploaded-file):not(.modify-uploaded-file)').remove();

        // 번호 컬럼을 구분으로 수정
        clone.find('table thead tr th').eq(0).text('구분');

        var trs = clone.find('table tbody tr');
        $.each(trs, function(index, item){
            var td = $(item).find('td').eq(0);

            if(!$(item).hasClass('uploaded-file')){
                $(td).html('신규');
            }else if($(item).hasClass('delete-uploaded-file')){
                $(td).text('삭제');
            }else if($(item).hasClass('modify-uploaded-file')){
                $(td).text('수정');
            }
        });
        
        // 작업 전체 카운트 
        totalCnt = clone.find('table tbody tr:not()').length;

        // 전체 업로드 진행 바 추가 
        clone.find('.tbl_comm').append(totalStatBarTmpl);
        clone.append(linkToList);
        //clone.find('table').append(totalStatBarTmpl);
        
        return clone;
    }

    var resetUploader = function(){
        if(!hasFiles()){
            alert('등록된 파일이 없습니다.');
            return;
        }

        uploader.dmUploader('reset');

        // 변수초기화
        fileList = {};
        no = 1;

        resetFileRows();
    }

    var showDimmer = function(isShow){
        if(isShow){
            $(document.body).append(dimmerTmpl);
        }else{
            $(document.body).find('.uploader-dimmer').remove();
        }
    }

    var dimmerClose = function(){
        showDimmer(false);
    }

    // util functions
    var sizeConv = function formatBytes(bytes, decimals ) {
    	decimals = 2;
        if (bytes === 0) return '0 Bytes';

        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

        const i = Math.floor(Math.log(bytes) / Math.log(k));

        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    }

    var getExt = function getExt(filename) {
        return filename.substr(filename.lastIndexOf('.') + 1);
    }
    
    var getUploader = function(){
        return uploader;
    }

    var hasFiles = function(){
        var result = false;

        // 신규, 삭제, 수정 파일이 다 없을 때
        if(!$.isEmptyObject(fileList) || $('.delete-uploaded-file').length > 0 || $('.modify-uploaded-file').length > 0){
            result = true;
        }

        return result;
    }
    
    var getMstSeq = function(){
    	return fmstSeq;
    }

    // return
    return {
        getUploader: getUploader,
        create: create,
        cancelFile: cancelFile,
        startUpload: startUpload,
        resetUploader: resetUploader,
        dimmerClose: dimmerClose,
        deleteFile: deleteFile,
        cancelDel: cancelDel,
        handleChangeType: handleChangeType,
        cancelMod: cancelMod,
        getMstSeq: getMstSeq,
    }
})(window, document, $);

window.uploadSrc = uploadSrc;