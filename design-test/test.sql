SELECT 6,
	193 AS upload_oid,
	1 AS STATUS,
	IIF(MAX(k.payroll_oid) = 0, ISNULL((
				SELECT MAX(oid)
				FROM payroll_firm
				WHERE id_reference = k.id_reference
					AND for_period = '202205'
				), 0), MAX(k.payroll_oid)) AS [payroll_oid],
	11 AS element_code,
	0 AS component_type,
	'202205' AS period_open,
	'202205' AS period_closed,
	SUM(ISNULL(k.amount, 0)) AS amount,
	IIF(MAX(k.grossup) = 1582, 1, 0) AS grossup,
	'35'
FROM (
	SELECT MAX(IIF(t1.for_period = '202205', t1.oid, 0)) AS payroll_oid,
		t1.id_reference AS id_reference,
		ISNULL(((ROUND(MAX(IIF(telement_code.[element_code] = 'EMPNODAYS', t1055.[amount], 0)) * MAX((ISNULL(IIF(t1011a.[rate_amount] IS NULL, IIF(t1011b.[rate_amount] IS NULL, IIF(t1011c.[rate_amount] IS NULL, t1011d.[rate_amount], t1011c.[rate_amount]), t1011b.[rate_amount]), t1011a.[rate_amount]), 0) / ISNULL(IIF(t1011a.[period_units] IS NULL, IIF(t1011b.[period_units] IS NULL, IIF(t1011c.[period_units] IS NULL, t1011d.[period_units], t1011c.[period_units]), t1011b.[period_units]), t1011a.[period_units]), 0))) / (MAX(IIF(telement_code.[element_code] = 'MONTHDAYS', t1055.[amount], 0))), 0))), 0) AS amount,
		MIN(ISNULL(ISNULL(t1011a.grossup, ISNULL(t1011b.grossup, ISNULL(t1011c.grossup, ISNULL(t1011d.grossup, 0)))), 0)) AS grossup
	FROM payroll_firm t1 WITH (NOLOCK)
	INNER JOIN identity_master t3 WITH (NOLOCK) ON (t1.id_reference = t3.id_reference)
	LEFT JOIN (
		SELECT *
		FROM payroll_firm_transaction WITH (NOLOCK)
		WHERE period_closed > '202203'
		) AS t1055 ON (t1.oid = t1055.payroll_oid)
	LEFT JOIN element_master telement_code WITH (NOLOCK) ON (t1055.element_code = telement_code.oid)
	INNER JOIN calendar_master t1040a WITH (NOLOCK) ON (
			t1040a.period = '202205'
			AND t1.for_period IN (
				SELECT DISTINCT [period]
				FROM calendar_master
				WHERE entity_code = '1'
					AND calendar_type = '2307'
					AND period = '202205'
				)
			AND t1040a.entity_code = '1'
			AND t1040a.calendar_type = '2307'
			AND t1040a.period_type IN (
				SELECT oid
				FROM code_master
				WHERE code = 'period_type'
					AND value = 'MY'
				)
			)
	LEFT JOIN calendar_master t1040 WITH (NOLOCK) ON (
			t1040.period = '202205'
			AND t1.for_period IN ('202205')
			AND t1055.period_closed = '202205'
			AND t1040.entity_code = '1'
			AND t1040.calendar_type = '2307'
			AND t1040.period_type IN (
				SELECT oid
				FROM code_master
				WHERE code = 'period_type'
					AND value = 'MY'
				)
			)
	INNER JOIN element_master telement_code_base WITH (NOLOCK) ON (telement_code_base.oid = '11')
	INNER JOIN id_entity_mapping_master t1080 WITH (NOLOCK) ON (
			t3.id_reference = t1080.id_reference
			AND t1080.period_from <= '202205'
			AND '202205' >= YEAR(t1080.effective_from_date) * 100 + MONTH(t1080.effective_from_date)
			AND '202205' <= YEAR(t1080.effective_to_date) * 100 + MONTH(t1080.effective_to_date)
			)
	INNER JOIN pay_group_identity_mapping t1101 WITH (NOLOCK) ON (
			t3.id_reference = t1101.id_reference
			AND t1101.period_from <= '202205'
			AND '202205' >= YEAR(t1101.effective_date_from) * 100 + MONTH(t1101.effective_date_from)
			AND '202205' <= YEAR(t1101.effective_date_to) * 100 + MONTH(t1101.effective_date_to)
			)
	INNER JOIN id_type_master t1079 WITH (NOLOCK) ON (
			t3.id_reference = t1079.id_reference
			AND t1079.period_from <= '202205'
			AND '202205' >= YEAR(t1079.effective_from_date) * 100 + MONTH(t1079.effective_from_date)
			AND '202205' <= YEAR(t1079.effective_date_to) * 100 + MONTH(t1079.effective_date_to)
			)
	INNER JOIN location_master t1076 WITH (NOLOCK) ON (
			t3.id_reference = t1076.id_reference
			AND t1076.period_from <= '202205'
			AND '202205' >= YEAR(t1076.effective_from_date) * 100 + MONTH(t1076.effective_from_date)
			AND '202205' <= YEAR(t1076.effective_to_date) * 100 + MONTH(t1076.effective_to_date)
			)
	INNER JOIN accounting_master t4 WITH (NOLOCK) ON (
			t3.id_reference = t4.id_reference
			AND t4.effective_from_date <= t1040.to_date
			AND t4.effective_to_date >= t1040.from_date
			)
	INNER JOIN unit_calendar_master t1077 WITH (NOLOCK) ON (
			t4.sub_area2 = t1077.sub_area2
			AND t1079.id_type = t1077.id_type
			AND t1079.id_sub_type1 = t1077.id_sub_type1
			AND t1040.period = t1077.period
			AND t4.business_area = t1077.business_area
			)
	INNER JOIN entity_master tentity_code WITH (NOLOCK) ON (t1080.entity_code = tentity_code.oid)
	INNER JOIN group_master tgroup_code WITH (NOLOCK) ON (tgroup_code.oid = tentity_code.group_code)
	INNER JOIN code_master tid_type WITH (NOLOCK) ON (t1079.id_type = tid_type.oid)
	INNER JOIN code_master tid_sub_type1 WITH (NOLOCK) ON (t1079.id_sub_type1 = tid_sub_type1.oid)
	LEFT JOIN code_master tid_sub_type2 WITH (NOLOCK) ON (t1079.id_sub_type2 = tid_sub_type2.oid)
	LEFT JOIN linkage_master tlinkage_master2 WITH (NOLOCK) ON (
			tid_type.value = tlinkage_master2.parent_value
			AND tid_sub_type1.value = tlinkage_master2.child_value
			)
	LEFT JOIN code_master tlinkage_name2 WITH (NOLOCK) ON (tlinkage_master2.linkage_name = tlinkage_name2.oid)
	LEFT JOIN rate_master t1011a WITH (NOLOCK) ON (
			t1011a.[period_from] <= t1040a.[period]
			AND t1011a.LEVEL = 'identity_emp'
			AND t3.id_reference = t1011a.level_value
			AND t1011a.effective_date <= t1040.to_date
			AND t1011a.effective_date_to >= t1040.from_date
			AND t1011a.output_code = telement_code_base.oid
			AND t1080.entity_code = t1011a.entity_code
			)
	LEFT JOIN rate_master t1011b WITH (NOLOCK) ON (
			t1011b.LEVEL = 'linkage_name'
			AND t1011b.level_value = tlinkage_name2.value
			AND t1011b.effective_date <= t1040.to_date
			AND t1011b.effective_date_to >= t1040.from_date
			AND t1011b.output_code = telement_code_base.oid
			AND t1080.entity_code = t1011b.entity_code
			)
	LEFT JOIN rate_master t1011c WITH (NOLOCK) ON (
			t1011c.LEVEL = 'id_type'
			AND t1011c.level_value = tid_type.value
			AND t1011c.effective_date <= t1040.to_date
			AND t1011c.effective_date_to >= t1040.from_date
			AND t1011c.output_code = telement_code_base.oid
			AND t1080.entity_code = t1011c.entity_code
			)
	LEFT JOIN rate_master t1011d WITH (NOLOCK) ON (
			t1011d.LEVEL = 'entity_code'
			AND t1011d.level_value = tentity_code.code
			AND t1011d.effective_date <= t1040.to_date
			AND t1011d.effective_date_to >= t1040.from_date
			AND t1011d.output_code = telement_code_base.oid
			AND t1080.entity_code = t1011d.entity_code
			)
	INNER JOIN code_master tbusiness_area WITH (NOLOCK) ON (t4.business_area = tbusiness_area.oid)
	INNER JOIN code_master tsub_area2 WITH (NOLOCK) ON (t4.sub_area2 = tsub_area2.oid)
	INNER JOIN pay_group_element_mapping t1102 WITH (NOLOCK) ON (
			t1101.pay_group_code = t1102.pay_group_code
			AND telement_code_base.oid = t1102.element_code
			AND t1102.entity_code = t1080.entity_code
			)
	WHERE 1 = 1
		AND ISNULL(t1011a.oid, ISNULL(t1011b.oid, ISNULL(t1011c.oid, ISNULL(t1011d.oid, 0)))) > 0
		AND (
			1 = 1
			AND (telement_code.[element_code] IN ('MONTHDAYS', 'EMPNODAYS'))
			AND (
				(tid_type.[Value] IN ('1A', '1B', '1C', '1AS', '1BS', '1CS', '1AJ', 'ST', 'ET', '1AI'))
				OR (tid_type.[Value] IN ('1D', '2A', '2B', '2C', '3X', '4X', '5X', 'ES', 'AMT', 'BLT', '3A', '3B', 'MCM', 'M1', 'M2', 'M3', 'M4', 'M5'))
				OR (tsub_area2.[Value] = 'LLPL MANAGER')
				OR tid_type.[Value] IN ('BLT', 'ST', 'OT', 'ECT')
				OR (tsub_area2.[Value] = 'LLPLSALON')
				OR tentity_code.[code] = 'HUVF'
				)
			AND (t1055.[amount] != 0)
			AND (t1055.[period_closed] = t1055.[period_open])
			AND (tid_sub_type1.[Value] != 'UWORK')
			)
		AND (
			1 = 1
			AND t1080.entity_code = '1'
			AND t1101.pay_group_code IN (5)
			AND t1040.calendar_type = '2307'
			AND t1101.pay_group_code IN (0, 1, 2, 5, 8, 9, 0)
			)
	GROUP BY t1.id_reference,
		t1.for_period,
		ISNULL(t1055.period_open, '')
	) AS k
WHERE 1 = 1
	AND k.amount <> 0
GROUP BY k.id_reference
OPTION (RECOMPILE)
