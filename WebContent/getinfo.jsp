
<jsp:directive.page import="java.sql.*" />
<jsp:directive.page import="java.io.IOException" />
<jsp:directive.page import="java.sql.*" />
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<body>

	<jsp:useBean id="db" class="DBBean.Bean" scope="page" />
	<%
		response.setContentType("text/xml; charset=utf-8");
		out.clear();
		try {
			String flag = request.getParameter("flag");
			String value = request.getParameter("value");
			if (flag == null) {
				return;
			}
			StringBuffer values = new StringBuffer("");

			ResultSet rs = null;
			//getconnection;
			//query
			//rs 
			if (flag.equals("1")) {
				rs = db.executeQuery(
						"select secondID,secondName from second where father='" + value + "' order by secondID");
				while (rs.next()) {
					values.append(rs.getString(1) + "," + rs.getString(2) + ";");
				}
				String ff = values.substring(0, values.indexOf(","));//最得敢小的市编号
				System.out.println(ff);
				rs = db.executeQuery(
						"select thirdID,thirdName from third where father='" + ff + "' order by thirdID");
				values.append("||");//区分市和区信息.
				while (rs.next()) {
					values.append(rs.getString(1) + "," + rs.getString(2) + ";");
				}
				System.out.println(values.toString());
			} else if (flag.equals("2")) {
				rs = db.executeQuery(
						"select thirdID,thirdName from third where father='" + value + "' order by thirdID");
				while (rs.next()) {
					values.append(rs.getString(1) + "," + rs.getString(2) + ";");
				}
			} else {
			}
			out.println(values.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	%>
</body>
</HTML>
