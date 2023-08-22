package com.ttmsoft.toaf.util;

public class PageInfo {

	private boolean debugPrint = false;
	private int PAGE_SIZE = 10;
	private int PAGE_GROUP = 10;
	private String PAGE_SCRIPT = "fncList";

	public void setPageSize(int iTemp) {
		this.PAGE_SIZE = iTemp;
	}

	public void setPageGroup(int iTemp) {
		this.PAGE_GROUP = iTemp;
	}

	public int getTotalPage(int iTemp) {
		int iTotalPage = 0;

		if (iTemp == 0) {
			iTotalPage = 1;
		}
		else if (iTemp % PAGE_SIZE == 0) {
			iTotalPage = iTemp / PAGE_SIZE;
		}
		else {
			iTotalPage = iTemp / PAGE_SIZE + 1;
		}

		return iTotalPage;
	}

	public int getTotalGroup(int iTemp) {
		int iTotalGroup = 0;

		if (iTemp % PAGE_GROUP == 0) {
			iTotalGroup = iTemp / PAGE_GROUP;
		}
		else {
			iTotalGroup = iTemp / PAGE_GROUP + 1;
		}

		return iTotalGroup;
	}

	public String makeIndex(int iCurPage, int iTotalCount) {
		return makeIndex(iCurPage, iTotalCount, PAGE_SIZE, PAGE_GROUP, PAGE_SCRIPT, "", "", "", "");
	}

	/**
	 * @param iCurPage : 현재페이지
	 * @param iTotalCount : 전체레코드수
	 * @param iPageSize : 페이지에 포함되는 레코드 수
	 * @return
	 */
	public String makeIndex(int iCurPage, int iTotalCount, int iPageSize) {
		setPageSize(iPageSize);
		return makeIndex(iCurPage, iTotalCount);
	}

	/**
	 * @param iCurPage : 현재페이지
	 * @param iTotalCount : 전체레코드수
	 * @param iPageSize : 페이지에 포함되는 레코드 수
	 * @param iPageGroup :
	 * @return
	 */
	public String makeIndex(int iCurPage, int iTotalCount, int iPageSize, int iPageGroup) {
		setPageGroup(iPageGroup);
		return makeIndex(iCurPage, iTotalCount, iPageSize);
	}
	
	/**
	 * 
	 * @param iCurPage 현재 페이지
	 * @param iTotalCount 전체 레코드 수
	 * @param iPageSize 페이지에 포함되는 레코드 수
	 * @param iPageGroup 페이지 그룹수
	 * @param sPageScript 페이지 스크립트 명
	 * @return
	 */
	public String makeIndex(int iCurPage, int iTotalCount, int iPageSize, int iPageGroup,
			String sPageScript) {
		return makeIndex(iCurPage, iTotalCount, iPageSize, iPageGroup, sPageScript, "", "", "", "");
	}
	
	public String makeIndex(int iCurPage, int iTotalCount, int iPageSize, int iPageGroup,
			String sPageScript, String menu_nm) {
		return makeIndex2(iCurPage, iTotalCount, iPageSize, iPageGroup, sPageScript, menu_nm, "", "", "");
	}

	/**
	 * @param iCurPage : 현재 페이지
	 * @param iTotalCount : 전체 목록 수
	 * @param iPageSize : 페이지에 포함되는 레코드 수
	 * @param iPageGroup : 페이지 그룹수
	 * @param sPageScript : 페이지 스크립트 명
	 * @param sFirst : 맨 처음 이미지
	 * @param sBack : 이전 이미지
	 * @param sNext : 다음 이미지
	 * @param sLast : 맨 끝 이미지
	 * @return
	 */
	public String makeIndex(int iCurPage, int iTotalCount, int iPageSize, int iPageGroup,
			String sPageScript,
			String sFirst, String sBack, String sNext, String sLast) {

		setPageSize(iPageSize);
		setPageGroup(iPageGroup);

		int iTotalPage = getTotalPage(iTotalCount); // 총 페이지
		int iTotalGroup = getTotalGroup(iTotalPage); // 총 페이지 그룹

		int iCurGroup = 1;
		int iTmp = iTotalPage;

		for (int i = 1; i <= iTotalGroup; i++) {
			if ((iCurPage <= i * iPageGroup) && (iCurPage > i)) {
				iCurGroup = i;
				break;
			}
			iTmp = iTmp - PAGE_GROUP;
		}

		if (sPageScript != null && sPageScript.trim().length() > 0) {
			sPageScript = sPageScript.trim();
		}
		else {
			sPageScript = PAGE_SCRIPT;
		}

		if (debugPrint) {
			System.out.println("==========================================================");
			System.out.println("iCurPage     : " + iCurPage);
			System.out.println("iTotalCount  : " + iTotalCount);
			System.out.println("iPageSize    : " + iPageSize + "\t PAGE_SIZE  : " + PAGE_SIZE);
			System.out.println("iPageGroup   : " + iPageGroup + "\t PAGE_GROUP : " + PAGE_GROUP);
			System.out.println("iTotalPage   : " + iTotalPage);
			System.out.println("iTotalGroup  : " + iTotalGroup);
			System.out.println("iCurGroup    : " + iCurGroup);
			System.out.println("==========================================================");
		}

		/**
		 * 처음 페이지로 이동할 이미지 경로
		*/ 
		if (sFirst != null && sFirst.trim().length() > 0) {
			sFirst = sFirst.trim();
		}
		else {
			//sFirst = "<span><img src='/images/front/paging/btn_paging_prev3.gif' alt='처음페이지로' /></span>";
			sFirst = "<span class=\"icon\" title='맨 처음 페이지로 이동' >맨 처음 페이지로 이동</span>";
		}

		/**
		 * 이전 페이지로 이동할 이미지 경로
		 */
		if (sBack != null && sBack.trim().length() > 0) {
			sBack = sBack.trim();
		}
		else {
			//sBack = "<span><img src='/images/front/paging/btn_paging_prev.gif' alt='이전 페이지'/></span>";
			sBack = "<span class=\"icon\"title='이전 페이지로 이동' >이전 페이지로 이동</span>";
		}

		/**
		 * 다음 페이지로 이동할 이미지 경로
		 */
		if (sNext != null && sNext.trim().length() > 0) {
			sNext = sNext.trim();

		}
		else {
			//sNext = "<span><img src='/images/front/paging/btn_paging_next.gif' alt='다음 페이지'/></span>";
			sNext = "<span class=\"icon\" title='다음 페이지로 이동'>다음 페이지로 이동</span>";
		}

		/**
		 * 끝 페이지로 이동할 이미지 경로
		*/ 
		if (sLast != null && sLast.trim().length() > 0) {
			sLast = sLast.trim();
		}
		else {
			//sLast = "<span><img src='/images/front/paging/btn_paging_next3.gif' alt='마지막페이지로' /></span>";
			sLast = "<span class=\"icon\" title='맨 끝 페이지로 이동 1' >맨 끝 페이지로 이동 1</span>";
		}

		StringBuffer sb = new StringBuffer();
		
		//sb.append("<p class='board_num'><strong>총게시물</strong>: "+iTotalCount+"개</p>");

		//sb.append("<div class='cboth pagination mg_tup20'>");
		sb.append("<span class=\"inner_paging\">");
		//sb.append("<ul class='pagination'>");
		
		
		if (iCurPage != 1) {                                         
			sb.append("<a href='javascript:;' class='btn_paging btn_fst' title='맨 처음 페이지로 이동' > ");
			sb.append("<span class='icon' onclick='" + sPageScript + "(1); return false;'>맨 처음 페이지로 이동</span>");
			sb.append("</a>");
//		    sb.append("  <span onclick='" + sPageScript + "(1); return false;'>                                      ");
//		    sb.append("    <span aria-hidden='true'>&lt;&lt;</span>      ");
//		    sb.append("  </span>                                     ");
//		    sb.append("</li>                                         ");
		}
		else {
			//sb.append(sFirst);
		}
		
		if (iCurGroup > 1) {
			//2012.09.03 adias2
			//페이징 처리시 이전페이지로 이동할때 계산대로 처리할경우 무조건 1이나옴.. 그래서 중간에 (PAGE_GROUP - 1)  삭제함
			//현재 계산식은 (2*10) - (10-1) - 10 = 1
			//수정 계산식 (2*10) -  10 = 10 --> 11페이지에서 이전버튼 눌렀을 경우 10페이지로 가야되는게 맞음.
			//sb.append("<a href='#' onclick=\"" + sPageScript + "('" + Integer.toString((iCurGroup * PAGE_GROUP) - (PAGE_GROUP - 1) - PAGE_GROUP) + "'); return false;\" class='prev'>");
			
			
			sb.append("<a href='javascript:;' class='btn_paging btn_prev' title='이전 페이지로 이동' > ");
			sb.append("<span class='icon' onclick='" +  sPageScript + "('" + Integer.toString((iCurGroup * PAGE_GROUP) - PAGE_GROUP) + "'); return false;'>이전 페이지로 이동</span>");
			sb.append("</a>");
			
//			sb.append("<li>                                          ");
//		    sb.append("  <span onclick=\"" + sPageScript + "('" + Integer.toString((iCurGroup * PAGE_GROUP) - PAGE_GROUP) + "'); return false;\" class='btn-prev'>                                      ");
//		    sb.append("    <span aria-hidden='true'>&lt;</span>      ");
//		    sb.append("  </span>                                     ");
//		    sb.append("</li>                                         ");
		}
		else {
			//sb.append(sBack);
		}
		//sb.append("</li> \n");

		for (int i = (iCurGroup * PAGE_GROUP) - (PAGE_GROUP - 1); i < (iCurGroup * PAGE_GROUP) + 1; i++) {
			if (i <= iTotalPage) {
//				if (i == iCurPage) {
//					sb.append("<strong>" + Integer.toString(i) + "</strong>");
//				}
//				else {
//					sb.append("<a href='#' onclick=\"" + sPageScript + "('"
//									+ Integer.toString(i)
//									+ "'); return false;\"  title='PAGE"
//									+ Integer.toString(i)
//									+ "'>"
//									+ Integer.toString(i) + "</a>");
//				}
				
				if (i == iCurPage) {
//					sb.append("<li class='active'>                                          ");
//					sb.append("  <span onclick=\""+ sPageScript + "('"+ Integer.toString(i) + "'); return false;\" >"+ Integer.toString(i)+" <span class='sr-only'>(current)</span></span>      ");
//					sb.append("</li>                                                        ");
					sb.append("<em class = 'link_page'>"+Integer.toString(i)+"</em>");
					
				}
				else {
					sb.append("<a href=\"#\" title=\""+Integer.toString(i)+"페이지로 이동 링크\" class=\"link_page\"");
					sb.append(" onclick=\""+ sPageScript + "('"+ Integer.toString(i) + "'); return false;\" >");
					sb.append(Integer.toString(i)+"</a>");
//					sb.append("<li>                                          ");
//					sb.append("  <span onclick=\""+ sPageScript + "('"+ Integer.toString(i) + "'); return false;\" >"+ Integer.toString(i)+"</span>      ");
//					sb.append("</li>                                                        ");
				}
			}
			if (i == iTotalPage) {
				break;
			}
		}

		if ((iCurGroup < iTotalGroup) && (iCurPage < iTotalPage)) {
			sb.append("<a class='btn_paging btn_next'title='다음 페이지로 이동'  href='#' onclick=\"" + sPageScript + "('" + Integer.toString(iCurGroup * PAGE_GROUP + 1) +"'); return false;\">");
			sb.append("<span class='icon'  >");
			sb.append("다음 페이지로 이동</span> ");
			sb.append("</a> ");
//			sb.append("<li>                                          ");
//		    sb.append("  <span onclick=\"" + sPageScript + "('" + Integer.toString(iCurGroup * PAGE_GROUP + 1) +"'); return false;\">                                      ");
//		    sb.append("    <span aria-hidden='true'>&gt;</span>      ");
//		    sb.append("  </span>                                     ");
//		    sb.append("</li>                                         ");
		    
		}
		else {
			//sb.append(sNext);
		}
		
		if (iCurPage != iTotalPage) {
			
			sb.append("<a class=\"btn_paging btn_lst\" title='맨 끝 페이지로 이동1' href=\"#\"  onclick=\"" + sPageScript + "('"+ iTotalPage + "'); return false;\" >");
			sb.append("<span class=\"icon\">맨 끝 페이지로 이동 1</span>");
			sb.append("</a>");
			sb.append("");
			
//		    sb.append("  <span onclick=\"" + sPageScript + "('"+ iTotalPage + "'); return false;\">                                      ");
//		    sb.append("    <span aria-hidden='true'>&gt;&gt;</span>      ");
//		    sb.append("  </span>                                     ");
//		    sb.append("</li>                                         ");
		    
		}
		else {
			//sb.append(sLast);
		}
		sb.append("</span>");
		//sb.append("</nav>");

		return sb.toString();
	}
	
	public String makeIndex2(int iCurPage, int iTotalCount, int iPageSize, int iPageGroup,
			String sPageScript,
			String menu_nm, String sBack, String sNext, String sLast) {

		setPageSize(iPageSize);
		setPageGroup(iPageGroup);
		String sFirst = "";

		int iTotalPage = getTotalPage(iTotalCount); // 총 페이지
		int iTotalGroup = getTotalGroup(iTotalPage); // 총 페이지 그룹

		int iCurGroup = 1;
		int iTmp = iTotalPage;

		for (int i = 1; i <= iTotalGroup; i++) {
			if ((iCurPage <= i * iPageGroup) && (iCurPage > i)) {
				iCurGroup = i;
				break;
			}
			iTmp = iTmp - PAGE_GROUP;
		}

		if (sPageScript != null && sPageScript.trim().length() > 0) {
			sPageScript = sPageScript.trim();
		}
		else {
			sPageScript = PAGE_SCRIPT;
		}

		if (debugPrint) {
			System.out.println("==========================================================");
			System.out.println("iCurPage     : " + iCurPage);
			System.out.println("iTotalCount  : " + iTotalCount);
			System.out.println("iPageSize    : " + iPageSize + "\t PAGE_SIZE  : " + PAGE_SIZE);
			System.out.println("iPageGroup   : " + iPageGroup + "\t PAGE_GROUP : " + PAGE_GROUP);
			System.out.println("iTotalPage   : " + iTotalPage);
			System.out.println("iTotalGroup  : " + iTotalGroup);
			System.out.println("iCurGroup    : " + iCurGroup);
			System.out.println("==========================================================");
		}

		/**
		 * 처음 페이지로 이동할 이미지 경로
		*/ 
		if (sFirst != null && sFirst.trim().length() > 0) {
			sFirst = sFirst.trim();
		}
		else {
			sFirst = "<span><img src='/images/NEW_SCIS/sub/btn_paging_prev3.gif' alt='처음페이지로' /></span>";
		}

		/**
		 * 이전 페이지로 이동할 이미지 경로
		 */
		
		menu_nm = menu_nm == null ? "게시물" : menu_nm;
		
		if (sBack != null && sBack.trim().length() > 0) {
			sBack = sBack.trim();
		}
		else {
			sBack = "<span><img src='/images/NEW_SCIS/sub/btn_paging_prev.gif' alt='"+menu_nm+" 이전 페이지'/></span>";
		}

		/**
		 * 다음 페이지로 이동할 이미지 경로
		 */
		if (sNext != null && sNext.trim().length() > 0) {
			sNext = sNext.trim();

		}
		else {
			sNext = "<span><img src='/images/NEW_SCIS/sub/btn_paging_next.gif' alt='"+menu_nm+" 다음 페이지'/></span>";
		}

		/**
		 * 끝 페이지로 이동할 이미지 경로
		*/
		if (sLast != null && sLast.trim().length() > 0) {
			sLast = sLast.trim();
		}
		else {
			sLast = "<span><img src='/images/NEW_SCIS/sub/btn_paging_next3.gif' alt='마지막페이지로' /></span>";
		}

		StringBuffer sb = new StringBuffer();
		
		//sb.append("<p class='board_num'><strong>총게시물</strong>: "+iTotalCount+"개</p>");

		//sb.append("<div class='cboth pagination mg_tup20'>");
		sb.append("<div class='paging'>");
		
		if (iCurPage != 1) {
			sb.append("<a href='#' onclick='" + sPageScript + "(1); return false;' class='btn_paging btn_fst'>");
			sb.append(sFirst);
			sb.append("</a>");
		}
		else {
			//sb.append(sFirst);
		}
		
		if (iCurGroup > 1) {
			//2012.09.03 adias2
			//페이징 처리시 이전페이지로 이동할때 계산대로 처리할경우 무조건 1이나옴.. 그래서 중간에 (PAGE_GROUP - 1)  삭제함
			//현재 계산식은 (2*10) - (10-1) - 10 = 1
			//수정 계산식 (2*10) -  10 = 10 --> 11페이지에서 이전버튼 눌렀을 경우 10페이지로 가야되는게 맞음.
			//sb.append("<a href='#' onclick=\"" + sPageScript + "('" + Integer.toString((iCurGroup * PAGE_GROUP) - (PAGE_GROUP - 1) - PAGE_GROUP) + "'); return false;\" class='prev'>");
			sb.append("<a href='#' onclick=\"" + sPageScript + "('" + Integer.toString((iCurGroup * PAGE_GROUP) - PAGE_GROUP) + "'); return false;\" title='뒤로가기' class='btn-prev'>");
			sb.append(sBack);
			sb.append("</a>");
		}
		else {
			//sb.append(sBack);
		}
		//sb.append("</li> \n");

		for (int i = (iCurGroup * PAGE_GROUP) - (PAGE_GROUP - 1); i < (iCurGroup * PAGE_GROUP) + 1; i++) {
			if (i <= iTotalPage) {
//				if (i == iCurPage) {
//					sb.append("<strong>" + Integer.toString(i) + "</strong>");
//				}
//				else {
//					sb.append("<a href='#' onclick=\"" + sPageScript + "('"
//									+ Integer.toString(i)
//									+ "'); return false;\"  title='PAGE"
//									+ Integer.toString(i)
//									+ "'>"
//									+ Integer.toString(i) + "</a>");
//				}
				
				if (i == iCurPage) {
					sb.append("<a href='#' onclick=\"" + sPageScript + "('"
							+ Integer.toString(i)
							+ "'); return false;\"  title='PAGE"
							+ Integer.toString(i)
							+ "' class='current' ><span>"
							+ Integer.toString(i) + "</span></a>");
				}
				else {
					sb.append("<a href='#' onclick=\"" + sPageScript + "('"
									+ Integer.toString(i)
									+ "'); return false;\"  title='PAGE"
									+ Integer.toString(i)
									+ "'><span>"
									+ Integer.toString(i) + "</span></a>");
				}
			}
			if (i == iTotalPage) {
				break;
			}
		}

		if ((iCurGroup < iTotalGroup) && (iCurPage < iTotalPage)) {
			sb.append("<a href='#' title='페이지이동' onclick=\"" + sPageScript + "('"
					+ Integer.toString(iCurGroup * PAGE_GROUP + 1)
					+ "'); return false;\" class='btn-next'>");
			sb.append(sNext);
			sb.append("</a>");
		}
		else {
			//sb.append(sNext);
		}
		
		if (iCurPage != iTotalPage) {
			sb.append("<a href='#' title='페이지이동' onclick=\"" + sPageScript + "('"
					+ iTotalPage + "'); return false;\" class='btn-next'>");
			sb.append(sLast);
			sb.append("</a>");
		}
		else {
			//sb.append(sLast);
		}
		sb.append("</div>");

		return sb.toString();
	}
}
