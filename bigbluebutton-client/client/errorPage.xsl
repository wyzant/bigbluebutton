<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
			<head>
				<title>WyzAnt Online Tutoring</title>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
				<link rel="shortcut icon" href="http://www.wyzant.com/images/wyzant.ico" />
				<link rel="Stylesheet" type="text/css" href="http://www.wyzant.com/Less/SiteMasterImports.less?v=47" />
				<style type="text/css" media="screen">
					#header{height:65px;background:url('http://wyzb1.wyzant.com/client/images/header.png') repeat-x;}
					#logo{margin:10px 0 0 5%;}
					html, body, #content    { height:100%;font-family: Tahoma;}
					body                                    { margin:0; padding:0; overflow:hidden; }
					#border{background:url('http://www.wyzant.com/Graphics/SiteV2/NavBG.gif');height:33px;}
					h1{border: medium none;font-size: 32px;font-weight: normal;margin: 5px 0;padding-bottom: 5px;text-align: left;}
					.customerService{margin-top:45px;}
					.errorCode{color:#aaa;font-size:.85em;}
					#header #SiteMaster_SiteHeader{background:none;border-bottom:0;height:auto;}
					#SiteMaster_SiteHeader div.LogoContainer{margin-top:0;}
				</style>
				<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
			</head>
			<body>
				<div id="header">
					<div id="SiteMaster_SiteHeader">
						<div class="Centered960">
							<div class="RightContainer"></div>
							<div class="LogoContainer">
								<img src="http://wyzb1.wyzant.com/client/images/logo.png" id="logo" />
							</div>
						</div>
					</div>
				</div>
				<div id="border"></div>
				<div id="SiteMaster_PageMainContent">
					<div class="Centered960">
						<div id="OneColumn">
							<h2>An Error Has Occurred</h2>
							<div>
								<xsl:choose>
									<xsl:when test="//messageKey='notFound'">
										We could not find the meeting your were looking for. <span class="errorCode">(error code: 1001)</span>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="/document/line/name='checksumError'">
										Our server had an internal configuration problem. <span class="errorCode">(error code: 2001)</span>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="/document/line/name='missingParamMeetingID'">
										We could not find the lesson id in your request. <span class="errorCode">(error code: 3001)</span>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="/document/line/name='idNotUnique'">
										A bad meeting id was passed in. <span class="errorCode">(error code: 4001)</span>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="/document/line/name='missingParamFullName'">
										A fullname was not passed in for an attendee. <span class="errorCode">(error code: 5001)</span>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="/document/line/name='missingParamFullName'">
										A bad password was passed in. <span class="errorCode">(error code: 6001)</span>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="/document/line/name='meetingForciblyEnded'">
										This lesson has been ended. <span class="errorCode">(error code: 7001)</span>
									</xsl:when>
								</xsl:choose>
								<div class="customerService">Please contact customer service if this problem persists <strong>(877) 999-2681</strong>.</div>
							</div>
						</div>
					</div>
				</div>
				<!--<div id="SiteMaster_PageFooter">
					<div class="Centered960">
						<div class="footerLinks">
							<h5>Get to know us</h5>
							<a href="/About/">About Us</a>
							<a href="/StudentWyzAntReviews.aspx">Reviews &amp; Testimonials</a>
							<a href="/TutorHiringSafetyTips.aspx">Safety</a>
							<a href="/Security.aspx">Security</a>
							<a href="/News">News</a>
							<a href="/ContactUs.aspx">Contact Us</a>
						</div>
						<div class="footerLinks">
							<h5>Learn with us</h5>
							<a href="/TutorSearchNew.aspx/">Search for a Tutor</a>
							<a href="/EmailTutor.aspx">Request a Tutor</a>
							<a href="/Help/Math/">Math Help</a>
							<a href="/Answers/">WyzAnt Answers</a>
							<a href="/Scholarships/">WyzAnt Scholarships</a>
						</div>
						<div class="footerLinks">
							<h5>Work with us</h5>
							<a href="/TutorHome.aspx">About Tutoring with Us</a>
							<a href="/TutorSignupStart.aspx">Become a Tutor</a>
							<a href="/JobSearch.aspx">Tutoring Jobs</a>
							<a href="/Partners/">Partners</a>
							<a href="/AffiliateProgram/">Affiliates</a>
						</div>
					</div>
				</div>-->
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
