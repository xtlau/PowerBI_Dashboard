/*Application funnel table*/
/*In the application funnel, we want to see whether a funding case has been through a particular decision phase.
 * Since one funding case can go through the same decision phase more than once, we can't just count the instances of that phase in the core_decsion table.
 * For instance, if a funding case goes through 4 DP statuses, we still want to show it as going through 1 DP phase, not 4. 
 * This code groups the decisions by phase and funding case to give one row for each decision phase/funding case pair. 
 * This will allow rolling up the distinct decision phases 9though count distinct on the funding case in Power BI should do the same thing)
 * Theresa Note: I originally started by trying to pivot these so we could have a matrix of the decision phases with a yes/no grid, but it was
 * proving difficult and not valuable enough, so if we need that, we should do it in Power BI
 */

DROP TABLE sdtc_reportdb_dev.sdtcreportsdomain.startup_funnel
CREATE TABLE sdtc_reportdb_dev.sdtcreportsdomain.startup_funnel
(
    startup_funnelguid int identity(1,1) PRIMARY KEY,
    fc_guid nvarchar(100) NOT NULL,
    fc_name nvarchar(100),
    dec_phaseguid nvarchar(100),
    dec_phasename nvarchar(100),
    dec_phase_bool bit
);

Insert into sdtc_reportdb_dev.sdtcreportsdomain.startup_funnel
	(   
    fc_GUID,
    fc_name,
    dec_phaseguid,
    dec_phasename,
    dec_phase_bool
	)
	(
	select 
		fc.core_fc_profileGUID,
		fc.core_name_en,
		cdp.core_decisionphaseguid,
		cdp.core_name,
		case when count(cd.core_decisionguid)>0 then 1 else 0 end as dec_phase_bool
	from sdtcbusinessdomain.core_fc_profile fc
	join sdtcbusinessdomain.core_decision cd
		on cd.sdtc_fundingcaseGUID=fc.core_fc_profileGUID
	join sdtcbusinessdomain.core_decisionphase cdp
		on cd.core_decisionphaseguid = cdp.core_decisionphaseguid
	where fc.core_fundingopportunity = '4AAA5153-0F60-EB11-A812-000D3A09C4B2' and cdp.core_decisiongroupGUID='1134CC35-5786-EB11-A812-000D3A09D422' /*NEED TO CHANGE TO SEED!!!!!!*/
	group by fc.core_fc_profileGUID, fc.core_name_en, cdp.core_decisionphaseguid, cdp.core_name
	);