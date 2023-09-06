<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script>
$(document).ready(function(){	

});

</script>
<form action="#" id="frm" name="frm" method="get">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="rows" id="rows" value="${paraMap.rows}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
				<div class="wrap_cont">
					<div class="sch_ctgr_wrap">
						<h2>매칭된 기업수요 목록</h2>
					<div class="sch_ctgr_list">
						<div class="sch_block_scroll">
							<ul class="sch_list_wrap sch_block_wrap" >
								<li><a href="#none" class="sch_list_btn " title="기술분야" data-d-ategory="">기술분야</a></li>
								<li><a href="#none" class="sch_list_btn last active" title="키워드검색" data-d-ategory="도서">키워드검색</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
</form>