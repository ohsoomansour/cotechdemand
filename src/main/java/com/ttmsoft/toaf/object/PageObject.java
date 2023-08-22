package com.ttmsoft.toaf.object;


/**
 * <PRE>
 * 기  능	: 기본 페이징 정보
 * 파일명	: PageObject.java
 * 패키지	: com.ttmsoft.lms.object
 * 설  명	: 
 * 변경이력	: 
 * 2020.03.03	[PUDDING] - 최초작성
 * 
 * </PRE>
 */
public class PageObject {

	/** 페이지 인덱스 */
	public int	page	= 1;

	/** 데이타 총수 */
	public int	rows	= 0;

	/** 페이지 크기 - 한페이지에 포함된 데이타 행수 */
	public int	size	= 10;

	/** 페이징 단위 */
	public int	unit	= 10;

	/**	정렬 필드명 */
	public String sidx = "";	
	
	/**	정렬 방향 (ASC or DESC) */
	public String sord = "";

	/**
	 * @return page - 페이지 인덱스 Getter
	 */
	public int getPage () {
		return page;
	}

	/**
	 * @param page - 페이지 인덱스 Setter
	 */
	public void setPage (int page) {
		this.page = page;
	}

	/**
	 * @return rows - 데이타 총수 Getter
	 */
	public int getRows () {
		return rows;
	}

	/**
	 * @param rows - 데이타 총수 Setter
	 */
	public void setRows (int rows) {
		this.rows = rows;
	}

	/**
	 * @return size - 페이지 크기 Getter
	 */
	public int getSize () {
		return size;
	}

	/**
	 * @param size - 페이지 크기 Setter
	 */
	public void setSize (int size) {
		this.size = size;
	}

	/**
	 * @return unit - 페이징 단위 Getter
	 */
	public int getUnit () {
		return unit;
	}

	/**
	 * @param unit - 페이징 단위 Setter
	 */
	public void setUnit (int unit) {
		this.unit = unit;
	}

	/**
	 * @return sidx - 정렬 필드명 Getter
	 */
	public String getSidx() {
		return sidx;
	}

	/**
	 * @param sidx - 정렬 필드명 Setter
	 */
	public void setSidx(String sidx) {
		this.sidx = sidx;
	}

	/**
	 * @return sord - 정렬 방향(ASC|DESC) Getter
	 */
	public String getSord() {
		return sord;
	}

	/**
	 * @param sord - 정렬 방향(ASC|DESC) Setter
	 */
	public void setSord(String sord) {
		this.sord = sord;
	}

	/**
	 * <PRE>
	 * 기  능	: 현재 페이지의 데이타 시작 인덱스
	 * 기능명	: getRowStart
	 * 설  명	: 현재 페이지의 데이타 시작 인덱스
	 * 변경이력	: 
	 * 2015. 7. 19.	[PUDDING] - 최초작성
	 * </PRE>
	 * 
	 * @return ((page - 1) * size)
	 */
	public int getRowStart () {
		return (page - 1) * size;
	}

	/**
	 * <PRE>
	 * 기  능	: 현재 페이지의 데이타 종료 인덱스
	 * 기능명	: getRowEnd
	 * 설  명	: 현재 페이지의 데이타 종료 인덱스
	 * 변경이력	: 
	 * 2015. 7. 19.	[PUDDING] - 최초작성
	 * </PRE>
	 * 
	 * @return	(getRowStart() + size)
	 */
	public int getRowEnd () {
		return getRowStart() + size;
	}

	/**
	 * <PRE>
	 * 기  능	: 총페이지 수
	 * 기능명	: getTotalPage
	 * 설  명	: 
	 * 변경이력	: 
	 * 2015. 7. 19.	[PUDDING] - 최초작성
	 * </PRE>
	 * 
	 * @return	((rows - 1) / size + 1)
	 */
	public int getTotalPage () {
		return (rows - 1) / size + 1;
	}

}
