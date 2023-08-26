<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script>
function fncChangeLang(lang){
	$.ajax({
		url : "/front/changeLang.do",
		type : "POST",
		data : {lang : lang},
		dataType : "json",
		success : function() {
			parent.$('#dialog').dialog('close');
		},
		error : function(){
			alert_popup('언어변경중 오류가 발생했습니다.');
		}
	});
}
</script>
<style>
.lang{font-size: 17px; font-weight: bold;}
</style>
<div style="text-align: center">
	<table>
		<caption class="caption_hide">언어변경</caption>
		<tr>
			<td style="padding-left: 30px">
				<a href="javascript:void(0);" onclick="fncChangeLang('KO'); return false;"><img src="/images/front/korea.png" title="한국어"></a><br>
				<span class="lang">한국어</span>
			</td>
			<td style="padding-left: 40px">
				<a href="javascript:void(0);" onclick="fncChangeLang('US'); return false;"><img src="/images/front/usa.png" title="영어"></a><br>
				<span class="lang">영어</span>
			</td>
		</tr>
	</table>
</div>