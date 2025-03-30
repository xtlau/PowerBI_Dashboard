--This table is all of the start up / scale up funding cases.
--It is intended to be the main FC table for startup funding cases
--This table pulls in some of the most common account and submission fields needed for funding case reporting, but we could remove that in the future.

DROP TABLE sdtc_reportdb_dev.sdtcreportsdomain.startup_funding_cases;

/*create the table*/
CREATE TABLE sdtc_reportdb_dev.sdtcreportsdomain.startup_funding_cases
(
    startup_funding_casesguid int identity(1,1) PRIMARY KEY,
    fc_guid nvarchar(100) NOT NULL,  	/* funding case id*/
    fc_name nvarchar(100),	/* funding name*/
    a_name nvarchar(300),	/* account name*/
    fc_decision_phaseid nvarchar(100), 
    fc_dec_phase nvarchar(300), /*current decision phase*/
    fc_dec_status nvarchar(300), /*current decision status*/
    fc_primary_lead nvarchar(300), 		/* primary lead GUID*/
    fc_sustainabilitysector nvarchar(300),
    a_province nvarchar(300), /* account province*/
    fc_sustainabilityimpactcategory nvarchar(300),
    fs_sdtcrequest money, /*Most current request. First looks at contracting request, then Approval, then DP, then submission*/
	s_submissionstamp datetime, /*date of submission*/
	fc_joint_call_name nvarchar(100), /*joint call partner*/
	fc_offrampapproved int, /*off ramp approval status*/
	/*NOTE: we should probably remove the sdtc part of these names to make them shorter*/
	fc_sdtc_offrrapplicationwithdrewfundingcase bit, /*off ramp reason*/
	fc_sdtc_offrrconsortium bit, /*off ramp reason*/
    fc_sdtc_offrrip bit, /*off ramp reason*/
    fc_sdtc_offrrscopeofproject bit, /*off ramp reason*/
    fc_sdtc_offrrsustainabilitybenefits bit, /*off ramp reason*/
    fc_sdtc_offrrbudget bit, /*off ramp reason*/
    fc_sdtc_offrrfundingcasetimedoutofprocess bit, /*off ramp reason*/
    fc_sdtc_offrrmanagementcapacity bit, /*off ramp reason*/
    fc_sdtc_offrrstdcwithdrewfundingcase bit, /*off ramp reason*/
    fc_sdtc_offrrtimeline bit, /*off ramp reason*/
    fc_sdtc_offrrcanadianretainedbenefits bit, /*off ramp reason*/
    fc_sdtc_offrrincompleteapplication bit, /*off ramp reason*/
    fc_sdtc_offrrmarketvalueproposition bit, /*off ramp reason*/
    fc_sdtc_offrrstageoftechnologydevelopment bit, /*off ramp reason*/
    fc_sdtc_debriefdate datetime /*off ramp debrief date*/
);

/*populate the table*/
Insert into sdtc_reportdb_dev.sdtcreportsdomain.startup_funding_cases 
	(   
    fc_GUID,
    fc_name,
    a_name,
    fc_decision_phaseid,
    fc_dec_phase,
    fc_dec_status,
    fc_primary_lead,
    fc_sustainabilitysector,
    a_province,
    fc_sustainabilityimpactcategory,
    s_submissionstamp,
    fc_joint_call_name,
    fc_offrampapproved,
    fc_sdtc_offrrapplicationwithdrewfundingcase,
    fc_sdtc_offrrconsortium,
    fc_sdtc_offrrip,
    fc_sdtc_offrrscopeofproject,
    fc_sdtc_offrrsustainabilitybenefits,
    fc_sdtc_offrrbudget,
    fc_sdtc_offrrfundingcasetimedoutofprocess,
    fc_sdtc_offrrmanagementcapacity,
    fc_sdtc_offrrstdcwithdrewfundingcase,
    fc_sdtc_offrrtimeline,
    fc_sdtc_offrrcanadianretainedbenefits,
    fc_sdtc_offrrincompleteapplication,
    fc_sdtc_offrrmarketvalueproposition,
    fc_sdtc_offrrstageoftechnologydevelopment,
    fc_sdtc_debriefdate
    )
    
select 
	fc.core_fc_profileguid,
	fc.core_name_en,
	a.name, 
	decp.core_decisionphaseGUID as fc_decision_phaseid,
	decp.core_name as fc_decision_phase,
	decs.core_name as fc_decision_status,
	fc.sdtc_primaryreviewerGUID,
	fc.sdtc_submissionsustainabilitysectorname,
	a.sdtc_address1provinceterritoryname,
	fc.sdtc_sustainabilityimpactcategoryname,
	s.sdtc_submissionstamp,
	fc.sdtc_jointcallname as fc_joint_call_name,
	fc.sdtc_offrampapproved as fc_offrampapproved,
	fc.sdtc_offrrapplicationwithdrewfundingcase as fc_sdtc_offrrapplicationwithdrewfundingcase,
	fc.sdtc_offrrconsortium as fc_sdtc_offrrconsortium,
	fc.sdtc_offrrip as fc_sdtc_offrrip,
	fc.sdtc_offrrscopeofproject as fc_sdtc_offrrscopeofproject,
	fc.sdtc_offrrsustainabilitybenefits as fc_sdtc_offrrsustainabilitybenefits,
	fc.sdtc_offrrbudget as fc_sdtc_offrrbudget,
	fc.sdtc_offrrfundingcasetimedoutofprocess as fc_sdtc_offrrfundingcasetimedoutofprocess,
	fc.sdtc_offrrmanagementcapacity as fc_sdtc_offrrmanagementcapacity,
	fc.sdtc_offrrstdcwithdrewfundingcase as fc_sdtc_offrrstdcwithdrewfundingcase,
	fc.sdtc_offrrtimeline as fc_sdtc_offrrtimeline,
	fc.sdtc_offrrcanadianretainedbenefits as fc_sdtc_offrrcanadianretainedbenefits,
	fc.sdtc_offrrincompleteapplication as fc_sdtc_offrrincompleteapplication,
	fc.sdtc_offrrmarketvalueproposition as fc_sdtc_offrrmarketvalueproposition,
	fc.sdtc_offrrstageoftechnologydevelopment as fc_sdtc_offrrstageoftechnologydevelopment,
	fc.sdtc_debriefdate as fc_sdtc_debriefdate
from sdtcbusinessdomain.core_fc_profile fc
	left join sdtcbusinessdomain.account a 
		on fc.core_accountGUID = a.accountGUID
	left join sdtcbusinessdomain.core_decisionphase decp 
		on fc.sdtc_decisionphaseGUID=decp.core_decisionphaseGUID
	left join sdtcbusinessdomain.core_decisionstatus decs 	/* to get name*/
		on fc.sdtc_decisionstatusGUID=decs.core_decisionstatusGUID					
	join sdtcbusinessdomain.core_fc_submission s
		on fc.core_fc_profileguid=s.core_fundingcaseguid
	where fc.core_fc_profileguid in 
		(
		select distinct fc.core_fc_profileguid
		from sdtcbusinessdomain.core_fc_profile fc
		left join sdtcbusinessdomain.core_decision d on fc.core_fc_profileGUID=d.sdtc_fundingcaseGUID
		left join sdtcbusinessdomain.core_decisionphase decp on d.core_decisionphaseGUID=decp.core_decisionphaseGUID
		left join sdtcbusinessdomain.core_decisionstatus decs on d.core_decisionstatusGUID=decs.core_decisionstatusGUID
		where fc.core_fundingopportunity='1133E1B1-7107-ED11-82E6-002248AE4D5A' 
		)

/*INVESTIGATION: submission investigation: for Startup/scaleup, we would expect that each funding case has one submission
select fc.core_fc_profileguid, count(*) from sdtcbusinessdomain.core_fc_profile fc
join sdtcbusinessdomain.core_fc_submission s
on fc.core_fc_profileguid=s.core_fundingcaseguid
where fc.core_fundingopportunityname='Start up / Scale up'
group by fc.core_fc_profileguid
having count(*)>1
RESULT: for startup/scaleup, there is only one submission per funding case at this time.*/
		
/*Add the funded request*/
/*ASSUMPTION/WARNING: This code assumes that there is only one row per 'view' type for the project funding table*/
/*the funded request has multiple locations in the funding case. It is first tracked in submission,
 * then updated at DP, then again at Approval and again at Contracting.
 * The submission value is found in the submission. The subsequent values are rows in the sdtc_projectfudningsdtc table.
 * To get the most up to date value, one hsa to look for all 4 of these values*/
update  sdtc_reportdb_dev.sdtcreportsdomain.startup_funding_cases
set fs_sdtcrequest=req.sdtc_fundingrequest
from(
	select 
		fc.core_fc_profileGUID,
		fc.core_name_en,
		coalesce (cont.sdtc_sdtcrequest, app.sdtc_sdtcrequest, dp.sdtc_sdtcrequest, sub.sdtc_amountrequestedsusu) as sdtc_fundingrequest
	from sdtcbusinessdomain.core_fc_profile fc
	left join
		(select * 
		from sdtcbusinessdomain.sdtc_projectfundingsdtc 
		where sdtc_viewname='Contracting'
		) cont
	on fc.core_fc_profileguid = cont.sdtc_fundingcaseguid
	left join
		(select * 
		from sdtcbusinessdomain.sdtc_projectfundingsdtc 
		where sdtc_viewname='Approval'
		) app
	on fc.core_fc_profileguid = app.sdtc_fundingcaseguid
	left join
		(--Note: the group by in this code should be removed after the migration duplication issue is fixed
		select sdtc_fundingcaseguid, max(sdtc_sdtcrequest) as sdtc_sdtcrequest
		from sdtcbusinessdomain.sdtc_projectfundingsdtc 
		where sdtc_viewname='Detailed Proposal'
		group by sdtc_fundingcaseguid
		) dp
	on fc.core_fc_profileguid = dp.sdtc_fundingcaseguid
	left join 
		(select core_fundingcaseguid, sdtc_amountrequestedsusu
		from sdtcbusinessdomain.core_fc_submission
		) sub
	on fc.core_fc_profileguid = sub.core_fundingcaseguid
	where fc.core_fundingopportunityname = 'Start up / Scale up'
) req
where fc_guid = req.core_fc_profileGUID