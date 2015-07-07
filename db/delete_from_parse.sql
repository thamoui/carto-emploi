DELETE  FROM parse
WHERE EXISTS (SELECT offer_id
              FROM job_offer
              WHERE (parse.id = job_offer.offer_id));
