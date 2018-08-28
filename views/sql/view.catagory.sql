select t.parent,t.id,t.text,t.jml) as text from

(
SELECT '1'::text AS parent,
    "left"(product.barcode::text, 3) AS id,
    ( SELECT supplier.name
           FROM supplier
          WHERE supplier.id::text = "left"(product.barcode::text, 3)) AS text,
    count(*) AS jml
   FROM product
  GROUP BY '1'::text, ("left"(product.barcode::text, 3)), (( SELECT supplier.name
           FROM supplier
          WHERE supplier.id::text = "left"(product.barcode::text, 3)))
UNION
 SELECT '2'::text AS parent,
    product.mclas AS id,
    ( SELECT mclass.name
           FROM mclass
          WHERE mclass.id::bpchar = product.mclas::bpchar) AS text,
    count(*) AS jml
   FROM product
  GROUP BY '2'::text, product.mclas, (( SELECT mclass.name
           FROM mclass
          WHERE mclass.id::bpchar = product.mclas::bpchar))
          ) t