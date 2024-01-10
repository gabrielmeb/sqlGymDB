-- Drop existing views
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'DROP VIEW PopularMembershipView';
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'DROP VIEW CancelledMembershipView';
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'DROP VIEW TrainerWorkLoadView';
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'DROP VIEW PopularGymsView';
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'DROP VIEW GymClassAttendanceView';
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
END;
/

-- Most popular membership type
CREATE VIEW PopularMembershipView AS
SELECT mpl.planname, mpl.duration, mpl.price, COUNT(mpu.planid) AS numPurchased
FROM MembershipPlan mpl
JOIN MembershipPurchase mpu ON mpl.planid = mpu.planid
GROUP BY mpl.planname, mpl.duration, mpl.price
ORDER BY COUNT(mpu.planid) DESC;
/
/*The reason this report is extremely important is because it provides an insight into which 
membership plan is the most popular within our customer base. Knowing this provides a lot of 
important information to make decisions about in regards to business operations. Knowing which 
plan is the most popular begs us to consider what type of amenities are included, the price and the perks. 
Looking at these factors can allow us to see why it's the most popular and then adjust other membership
plans around the same guideline or headspace that this was designed to be. If the most popular for example
 was the cheapest one. Maybe improving equipment and experience in the gym could allow us to charge more. 
 And if the least popular is the most expensive. Offering more to customers may entice them to purchase the plan. 
 This report allows us to consider a lot of variables to make informed business decisions.
*/
-- Cancelled Membership by facility 
CREATE VIEW CancelledMembershipView AS
SELECT fc.facilityname, fc.city, fc.addressline1, COUNT(mp.isCancelled) AS numCancelled
FROM Facility fc
JOIN Member m ON fc.facilityid = m.facilityid
JOIN MembershipPurchase mp ON m.memberid = mp.memberid
WHERE mp.isCancelled = 1
GROUP BY fc.facilityname, fc.city, fc.addressline1
ORDER BY numCancelled DESC;
/
/*This business report provides us with a crucial piece of information that is vital 
to our business. Knowing and understanding which membership plans have been cancelled 
the most is crucial into understanding what improvements we need to make as a business 
to ensure customer retention. Knowing which plans were cancelled the most can be utilized
to see what changes can be implemented in the future to keep people there. We can consider
things like price and membership details to see if plans were too expensive or included 
redundant things. Cancelled plans are imperative to improving things about out product 
that aren't working well or as intended. 
*/

-- Lists the trainers that are managing the most classes in descending order.
CREATE VIEW TrainerWorkLoadView AS
SELECT t.trainerID, t.lastName, t.firstName, COUNT(gc.classID) AS numClasses
FROM Trainer t
LEFT JOIN GymClass gc ON t.trainerID = gc.trainerID
GROUP BY t.trainerID, t.lastName, t.firstName
ORDER BY COUNT(gc.classID) DESC;
/

/*
This query lists the the trainers that are managing the most classes in descending order.
This can provide us with information on workers schedules, workload and demand. This report 
can also be extremely important when combined with the first report as well. If we combine 
the information of what classes are the most popular along with the information of which trainers 
are managing which classes we can see how well employees are performing. This can then be used
to give lower performers more opportunity to succeed and get their classes to perform better
and also reward top performers as well.

*/

-- Most popular gym locations -> redo this one include count of the facility
CREATE VIEW PopularGymsView AS
SELECT f.facilityName, f.city, f.state, COUNT(m.memberID) AS numMembers
FROM Facility f
LEFT JOIN Member m ON m.facilityID = f.facilityID
GROUP BY f.facilityName,f.city, f.state
ORDER BY numMembers DESC;
/
/*
This report allows us to see what locations are the most popular. This is extremely 
important as we can see which locations/cities are the most in demand and thus allow 
us to open more locations with certain areas. Along with this we can combine this 
information with what gym classes are the most popular within these areas and recruit
more trainers and members who are more interested in that specialty. An example of this 
could be that bodybuilding is more popular in Toronto so the marketing for the gym would 
cater more toward bodybuilding in that area but in Chicago powerlifting may be the more 
popular market. Tweaking this query could allow for a lot of insight into multiple aspects
of the business.
*/

--Most popular gym classes at across all gyms
CREATE VIEW GymClassAttendanceView AS
SELECT gc.classID, gc.className, COUNT(a.memberID) AS numAttendees
FROM GymClass gc
LEFT JOIN ClassMemberMap a ON gc.classID = a.classID
GROUP BY gc.classID, gc.className
ORDER BY numAttendees DESC;
/
/*
This report provides information on which classes have the most members enrolled within
 he gyms under our management. This information will provide us with the ability to see 
which class has the most appeal for gym members to go to and thus provide us with a
plethora of oppurtunities and ideas to make business decisions. An example of this 
could be to implement the class in multiple gyms so that the members from different
gyms and different locations can enrol into the class which would then add more appeal
to the gym. Another way would be to have the class happen multiple times throughout 
the day/week to provide the members of the gym to try the class since it is already very
popular. This could also lead to new members joining because of the class. 
*/

/*
SELECT * FROM PopularMembershipView;
SELECT * FROM CancelledMembershipView;
SELECT * FROM TrainerWorkLoadView;
SELECT * FROM PopularGymsView;
SELECT * FROM GymClassAttendanceView;
*/


