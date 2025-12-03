//
//  PaginationUtils.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 21/11/25.
//

import Smart1SDK_iOS

struct PaginationUtils {
    static func getPaginatedData<T>(
        getData        : @escaping (Int) async -> DataSet<T>?,
        onProgress     : (@Sendable (Int, Int) async -> Void)? = nil,
        onDataProgress : (@Sendable ([T]) async -> Void)? = nil
    ) async -> [T] {
        var allData: [T] = []
        var countOfRecords = 0
        
        guard let firstData = await getData(1) else {
            return allData
        }
        
        allData.append(contentsOf: firstData.records)
        countOfRecords += firstData.records.count
        await onProgress?(countOfRecords, firstData.pagination.totalRecords)
        await onDataProgress?(firstData.records)
        
        if firstData.pagination.totalPages <= 1 {
            return allData
        }
        
        var currentPage = 2
        while currentPage <= firstData.pagination.totalPages {
            guard let somePageData = await getData(currentPage) else {
                break
            }
            allData.append(contentsOf: somePageData.records)
            countOfRecords += somePageData.records.count
            await onProgress?(countOfRecords, somePageData.pagination.totalRecords)
            await onDataProgress?(somePageData.records)
            currentPage += 1
        }
        
        return allData
    }
}
