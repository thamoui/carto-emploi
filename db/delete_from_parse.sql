DELETE  FROM parse
WHERE EXISTS (SELECT offer_id
              FROM job_offers
              WHERE (parse.id = job_offers.offer_id));
