//
//  Arguments.swift
//  rmv
//
//  Created by Elangovan Ayyasamy on 08/08/21.
//

import Foundation


class Arguments
{
    public private( set ) var directories = false
    public private( set ) var force       = false
    public private( set ) var interactive = false
    public private( set ) var recursive   = false
    public private( set ) var verbose     = false
    public private( set ) var files       = [ String ]()
}
