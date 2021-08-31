//
//  database.swift
//  LenseTracker
//
//  Created by Мак on 31.08.2021.
//

import Foundation

/*
 
 sql to get data from database for current lens complect:
 
 select
 lenses.id,
 (select supplier from lense where id = lenses.left_eye) as my_supplier_left,
 (select model from lense where id = lenses.left_eye) as my_model_left,
 lenses.days_left_eye,
 (select supplier from lense where id = lenses.right_eye) as my_supplier_right,
 (select model from lense where id = lenses.right_eye) as my_model_right,
 lenses.days_right_eye
 from lenses
 where lenses.id = 1
 
 */
