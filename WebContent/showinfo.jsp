
<jsp:directive.page import="java.sql.*" />
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAd>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Ajax实现三级联动下拉框</TITLE>
<script type="text/javascript">
	if (window.ActiveXObject && !window.XMLHttpRequest) {
		window.XMLHttpRequest = function() {
			return new ActiveXObject((navigator.userAgent.toLowerCase()
					.indexOf('msie 6') != -1) ? 'Microsoft.XMLHTTP'
					: 'Msxml2.XMLHTTP');
		};
	}//取得XMLHttpRequest对象 
	var req;
	var flagSelect;
	function testName(flag, value)//使用Ajax访问服务器
	{
		flagSelect = flag; //标记一下当前是选择省,还是选择市
		req = new XMLHttpRequest();
		if (req) {
			req.onreadystatechange = setValue;
		}
		req.open('POST', "getinfo.jsp?flag=" + flag + "&value=" + value);//把参数带到服务器中
		req.setRequestHeader('Content-Type',
				'application/x-www-form-urlencoded');
		req.send(null);
	}
	function setValue() {
		if (req.readyState == 4)//访问到服务器
		{
			if (req.status == 200)//正确返回
			{
				if (flagSelect == "1")//如果选择某个省要更新市和区
				{
					var v = req.responseText.split("||");//req.responseText是服务器返回来的字符串
					paint(document.all("sec"), v[0]);//更新市下拉框
					paint(document.all("thi"), v[1]);//更新区下拉框
				}
				if (flagSelect == "2")//如果选择某市,只需改变区
				{
					var v = req.responseText;//req.responseText是服务器返回来的字符串
					paint(document.all("thi"), v);//更新区下拉框
				}
			}
		}
	}
	function paint(obj, value)//根据一对数据去更新一个下拉框
	{
		var ops = obj.options;
		var v = value.split(";");//得到一些数据,(修改过了..)
		while (ops.length > 0)//先清空原来的数据
		{
			ops.remove(0);
		}
		for (var i = 0; i < v.length - 1; i++)//把新得到的数据显示上去
		{
			var o = document.createElement("OPTION");//创建一个option把它加到下拉框中
			o.value = v[i].split(",")[0];
			o.text = v[i].split(",")[1];
			ops.add(o);
		}
	}
</script>
<body>
	<h2 align=center>学科分类三级联动下拉框</h2>

	<jsp:useBean id="db" class="DBBean.Bean" scope="page" />

	<table align=center>
		<tr>
			<%
				ResultSet rs = db.executeQuery("select * from first order by firstID");
			%>
			<td>一级学科<select name="fir" onchange="testName(1,this.value);">
					<%
						while (rs.next()) {
							out.println(
									"<option value='" + rs.getString("firstID") + "'>" + rs.getString("firstName") + "</option>");
						}
					%>
			</select>
			</td>
			<%
				rs = db.executeQuery(
						"select * from second t2 where t2.father=(select min(t1.firstID) from first t1) order by secondID");
			%>
			<td>二级学科<select name="sec" onchange="testName(2,this.value);">
					<%
						while (rs.next()) {
							out.println("<option value='" + rs.getString("secondID") + "'>" + rs.getString("secondName") + "</option>");
						}
					%>
			</select>
			</td>
			<%
				rs = db.executeQuery(
						"select * from third t3 where t3.father=(select min(t2.secondID) from second t2 where t2.father=(select min(t1.firstID) from first t1) ) order by thirdID");
			%>
			<td>三级学科<select name="thi">
					<%
						while (rs.next()) {
							out.println(
									"<option value='" + rs.getString("thirdID") + "'>" + rs.getString("thirdName") + "</option>");
						}
						rs.close();
					%>
			</select>
			</td>
		</tr>
	</table>
</body>
</HTML>
