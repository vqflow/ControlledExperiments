select
    class_info.class_id,
    class_info.class_desc,
    class_info.dmn_id,
    class_info.qual_id,
    class_info.start_dte,
    class_info.end_dte,
    class_info.max_size,
    class_info.dmn_desc,
    class_info.qual_title,
    schedule_info.start_dte,
    schedule_info.end_dte,
    schedule_info.schd_id,
    schedule_info.cpnt_typ_id,
    schedule_info.act_cpnt_id,
    schedule_info.rev_dte,
    schedule_info.timezone_id,
    schedule_info.display_in_schd_tz,
    schedule_info.rev_num,
    other_class_info.col_num,
    other_class_info.label,
    other_class_info.user_value,
    other_class_info.user_desc,
    student_info.stud_id,
    student_info.class_stat_id,
    student_info.comments,
    student_info.lname,
    student_info.name,
    student_info.mi,
    student_info.class_stat_desc
from
select
    class_info.class_id,
    class_info.class_desc,
    class_info.dmn_id,
    class_info.qual_id,
    class_info.start_dte,
    class_info.end_dte,
    class_info.max_size,
    class_info.dmn_desc,
    class_info.qual_title
from
    (
        select
            pc.class_id,
            pc.class_desc,
            psc.dmn_id,
            pc.qual_id,
            pc.start_dte,
            pc.end_dte,
            pc.max_size,
            pd.dmn_desc,
            pq.qual_title
        from
            pa_class pc
            join pa_domain pd
            join pa_qual pq on pc.dmn_id = pd.dmn_decs
            and pc.qual_id = qp.qual_id
    ) class_info
    join
select
    schedule_info.start_dte,
    schedule_info.end_dte,
    schedule_info.class_id,
    schedule_info.schd_id,
    schedule_info.cpnt_typ_id,
    schedule_info.act_cpnt_id,
    schedule_info.rev_dte,
    schedule_info.timezone_id,
    schedule_info.display_in_schd_tz,
    schedule_info.rev_num
from
    (
        select
            psr.start_dte,
            psr.end_dte,
            pcs.class_id,
            pcs.schd_id,
            ps.cpnt_typ_id,
            ps.act_cpnt_id,
            ps.rev_dte,
            ps.timezone_id,
            ps.display_in_schd_tz,
            pc.rev_num
        from
            ps_schd_resources psr
            join pa_class_sched pcs
            join pa_sched
            join pv_course on psr.schd_id = pcs.schd_id
            and pcs.schd_id = ps.schd_id
            and ps.cpnt_typ_id = pc.cpnt_typ_id
            and ps.act_cpnt_id = pc.act_cpnt_id
            and ps.rev_dte = pc.rev_dte
    ) schedule_info
    join
select
    other_class_info.class_id,
    other_class_info.col_num,
    other_class_info.label,
    other_class_info.user_value,
    other_class_info.user_desc
from
    (
        select
            all_class_info.class_id,
            all_class_info.col_num,
            all_class_info.label,
            pcu.user_value,
            puc.user_desc
        from
            (
                select
                    pc.class_id,
                    puc.col_num,
                    puc.label
                from
                    pa_class pc,
                    pa_usrcl_class puc
            ) all_class_info
            join pa_class_user pcu
            join pa_usrrf_class puc on all_class_info.class_id = pcu.class_id
            and all_class_info.col_num = pcu.col_num
            and pcu.user_value = puc.user_id
    ) other_class_info
    join
select
    student_info.class_id,
    student_info.stud_id,
    student_info.class_stat_id,
    student_info.comments,
    student_info.lname,
    student_info.name,
    student_info.mi,
    student_info.class_stat_desc
from
    (
        select
            pcs.class_id,
            pcs.stud_id,
            psc.class_stat_id,
            pcs.comments,
            ps.lname,
            ps.name,
            ps.mi,
            pcst.class_stat_desc
        from
            pa_class_student pcs
            join pa_student ps
            join pa_class_stat psct on pcs.stud_id = ps.stud_id
            and ps.class_stat_id = psct.class_stat_id
    ) student_info on class_info.class_id = student_info.class_id
    and class_info.class_id = other_class_info.class_id
    and class_info.class_id = schedule_info.class_id