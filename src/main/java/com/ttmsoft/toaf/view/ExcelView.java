package com.ttmsoft.toaf.view;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Color;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
//import org.springframework.web.servlet.view.document.AbstractExcelView;
import org.springframework.web.servlet.view.document.AbstractXlsView;

import com.ttmsoft.toaf.object.DataMap;

@SuppressWarnings ({ "unchecked", "unused", "static-access", "deprecation" })
public class ExcelView extends AbstractXlsView {

	private static final String EXTENSION = ".xls";

	@Override
	protected void buildExcelDocument (	Map<String, Object> model,
										Workbook wbook,
										HttpServletRequest request,
										HttpServletResponse response) throws Exception {

		//---------------------------------------------------------------------
		// model : { excelname, sheetlist }
		//---------------------------------------------------------------------

		String excelName = URLEncoder.encode(model.get("excelname").toString(), "UTF-8");
		System.out.println(excelName);
//		String excelName = new String(model.get("excelName").toString().getBytes("euc-kr"), "8859_1");
		
		CellStyle lbl_css = wbook.createCellStyle();
		CellStyle hdr_css = wbook.createCellStyle();
		CellStyle dat_css = wbook.createCellStyle();
		
		Font lbl_fnt = wbook.createFont();
		Font dat_fnt = wbook.createFont();
		
		lbl_fnt.setFontHeightInPoints((short) 14);
		lbl_fnt.setColor(lbl_fnt.COLOR_NORMAL);
		lbl_fnt.setBold(true);
		lbl_fnt.setFontName("굴림체");
		
		dat_fnt.setFontHeightInPoints((short) 9);
		dat_fnt.setFontName("굴림체");

		lbl_css.setFont			(lbl_fnt);
		
		hdr_css.setBorderTop	(BorderStyle.THIN);
		hdr_css.setBorderBottom	(BorderStyle.THIN);
		hdr_css.setBorderLeft	(BorderStyle.THIN);
		hdr_css.setBorderRight	(BorderStyle.THIN);
		hdr_css.setFillPattern	(FillPatternType.THIN_VERT_BANDS);
		hdr_css.setAlignment	(HorizontalAlignment.CENTER);		
		hdr_css.setFont			(dat_fnt);
		hdr_css.setFillForegroundColor(HSSFColorPredefined.GREY_25_PERCENT.getIndex());
		
		dat_css.setBorderTop	(BorderStyle.THIN);
		dat_css.setBorderBottom	(BorderStyle.THIN);
		dat_css.setBorderLeft	(BorderStyle.THIN);
		dat_css.setBorderRight	(BorderStyle.THIN);
		dat_css.setAlignment	(HorizontalAlignment.LEFT);		
		dat_css.setFont			(dat_fnt);

		List<DataMap> sheetList = (List<DataMap>) model.get("sheetlist");

		//---------------------------------------------------------------------
		// sheetMap : { sheetname, title, header, volist }
		//---------------------------------------------------------------------
		for (DataMap sheetMap : sheetList) {
			int rowidx	= 0;
			String[]		arrHead = (String[]) sheetMap.get("header");
			List<String[]>	lstData = (List<String[]>) sheetMap.get("volist");
			
			// POI 객체 생성
			logger.debug("================== sheet:"+sheetMap.get("sheetname"));
			Sheet sheet = wbook.createSheet(sheetMap.get("sheetname").toString());


			// 타이틀 로우를 만들어낸다
			Row title = sheet.createRow(rowidx++);
			Cell tcell = title.createCell(0); tcell.setCellValue(sheetMap.get("title").toString()); tcell.setCellStyle(lbl_css);
			
			sheet.createRow(rowidx++);
			
			// 타이틀 로우를 만들어낸다
			Row header = sheet.createRow(rowidx++);
			for (int idx = 0, len = arrHead.length; idx < len; idx++) {
				Cell hcell = header.createCell((short) idx); hcell.setCellValue(arrHead[idx]); hcell.setCellStyle(hdr_css);
			}

			// 데이터 입력
			for (int yidx = 0, ylen = lstData.size(); yidx < ylen; yidx++) {
				Row xlsrow = sheet.createRow(rowidx++);
				String[] voitem = (String[]) lstData.get(yidx);
				for (int xidx = 0, xlen = arrHead.length; xidx < xlen; xidx++) {
					Cell dcell = xlsrow.createCell((short) xidx); dcell.setCellValue(voitem[xidx] + ""); dcell.setCellStyle(dat_css);
				}
			}

		}
	
        response.setContentType("application/msexcel");
        response.setHeader("Content-Disposition", "attachment; filename=\""+excelName+".xls\";");
        response.setHeader("Content-Transfer-Encoding", "binary");
	}

}
