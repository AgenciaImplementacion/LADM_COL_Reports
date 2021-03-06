SELECT array_to_json(array_agg(features)) AS features
                    FROM (
                        SELECT f AS features
                        FROM (
                            SELECT 'Feature' AS type
                                ,row_to_json((
                                    SELECT l
                                    FROM (
                                        SELECT left(right(numero_predial,15),6) AS predio --parametrizar atributo numero_predial
                                        ) AS l
                                    )) AS properties
                                ,ST_AsGeoJSON(geometria, 4, 0)::json AS geometry --parametrizar geometria
                            FROM ladm_lev_cat_v1.lc_terreno AS l --parametrizar schema y tabla
                            LEFT JOIN ladm_lev_cat_v1.col_uebaunit ON l.t_id = ue_lc_terreno --parametrizar schema, tabla y atributo
                            LEFT JOIN ladm_lev_cat_v1.lc_predio ON lc_predio.t_id = baunit --parametrizar schema, tabla y atributo
                            -- The selection of the filter depends on: If you want a selected plot or all associated plots
							WHERE l.t_id = 1432 --parametrizar WHERE
							--WHERE l.geometria && (SELECT ST_Expand(ST_Envelope(lc_terreno.geometria), 1000) FROM ladm_lev_cat_v1.lc_terreno WHERE t_id = 1432) AND l.t_id != 1432
                            ) AS f
                        ) AS ff;