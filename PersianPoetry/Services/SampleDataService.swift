//
//  SampleDataService.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import Foundation

class SampleDataService {
    static let shared = SampleDataService()
    
    private init() {}
    
    func getSamplePoems() -> [Poem] {
        let allPoems = [
            Poem(
                id: 1,
                title: "در دل من مها",
                urlSlug: "ghazal-1",
                plainText: "در دل من مها که جانی داری\nتو به هر حالی که باشی، آنی داری\n",
                htmlText: "<p>در دل من مها که جانی داری<br>تو به هر حالی که باشی، آنی داری</p>",
                poet: Poet(
                    id: 1,
                    name: "حافظ",
                    description: "شاعر بزرگ ایرانی",
                    birthYear: 1325,
                    deathYear: 1390
                ),
                category: Category(
                    id: 1,
                    title: "غزل",
                    urlSlug: "ghazal",
                    parentId: nil
                )
            ),
            Poem(
                id: 2,
                title: "ای کاش که جای آشنایی",
                urlSlug: "robai-1",
                plainText: "ای کاش که جای آشنایی بودی\nیا در ره منزل آشنایی بودی\n",
                htmlText: "<p>ای کاش که جای آشنایی بودی<br>یا در ره منزل آشنایی بودی</p>",
                poet: Poet(
                    id: 2,
                    name: "عمر خیام",
                    description: "شاعر و فیلسوف ایرانی",
                    birthYear: 1048,
                    deathYear: 1131
                ),
                category: Category(
                    id: 2,
                    title: "رباعی",
                    urlSlug: "robai",
                    parentId: nil
                )
            ),
            Poem(
                id: 3,
                title: "بشنو از نی",
                urlSlug: "masnavi-1",
                plainText: "بشنو از نی چون حکایت می‌کند\nوز جدایی‌ها شکایت می‌کند\n",
                htmlText: "<p>بشنو از نی چون حکایت می‌کند<br>وز جدایی‌ها شکایت می‌کند</p>",
                poet: Poet(
                    id: 3,
                    name: "مولوی",
                    description: "شاعر و عارف بزرگ",
                    birthYear: 1207,
                    deathYear: 1273
                ),
                category: Category(
                    id: 3,
                    title: "مثنوی",
                    urlSlug: "masnavi",
                    parentId: nil
                )
            ),
            Poem(
                id: 4,
                title: "چو در دل من مها",
                urlSlug: "ghazal-2",
                plainText: "چو در دل من مها که جانی داری\nتو به هر حالی که باشی، آنی داری\n",
                htmlText: "<p>چو در دل من مها که جانی داری<br>تو به هر حالی که باشی، آنی داری</p>",
                poet: Poet(
                    id: 4,
                    name: "سعدی",
                    description: "شاعر و نویسنده بزرگ ایرانی",
                    birthYear: 1210,
                    deathYear: 1291
                ),
                category: Category(
                    id: 1,
                    title: "غزل",
                    urlSlug: "ghazal",
                    parentId: nil
                )
            ),
            Poem(
                id: 5,
                title: "ای کاش که جای آشنایی",
                urlSlug: "robai-2",
                plainText: "ای کاش که جای آشنایی بودی\nیا در ره منزل آشنایی بودی\n",
                htmlText: "<p>ای کاش که جای آشنایی بودی<br>یا در ره منزل آشنایی بودی</p>",
                poet: Poet(
                    id: 5,
                    name: "فردوسی",
                    description: "شاعر حماسه‌سرای ایرانی",
                    birthYear: 940,
                    deathYear: 1020
                ),
                category: Category(
                    id: 2,
                    title: "رباعی",
                    urlSlug: "robai",
                    parentId: nil
                )
            ),
            Poem(
                id: 6,
                title: "اگر چه باده فرح بخش",
                urlSlug: "ghazal-3",
                plainText: "اگر چه باده فرح بخش و باد\nولیکن باده با ساقی خوش است\n",
                htmlText: "<p>اگر چه باده فرح بخش و باد<br>ولیکن باده با ساقی خوش است</p>",
                poet: Poet(
                    id: 6,
                    name: "حافظ",
                    description: "شاعر بزرگ ایرانی",
                    birthYear: 1325,
                    deathYear: 1390
                ),
                category: Category(
                    id: 1,
                    title: "غزل",
                    urlSlug: "ghazal",
                    parentId: nil
                )
            ),
            Poem(
                id: 7,
                title: "این کوزه گر دیده‌ام",
                urlSlug: "robai-3",
                plainText: "این کوزه گر دیده‌ام بر خاک\nبا خاکیان در خاک می‌ساخت\n",
                htmlText: "<p>این کوزه گر دیده‌ام بر خاک<br>با خاکیان در خاک می‌ساخت</p>",
                poet: Poet(
                    id: 7,
                    name: "عمر خیام",
                    description: "شاعر و فیلسوف ایرانی",
                    birthYear: 1048,
                    deathYear: 1131
                ),
                category: Category(
                    id: 2,
                    title: "رباعی",
                    urlSlug: "robai",
                    parentId: nil
                )
            ),
            Poem(
                id: 8,
                title: "بشنو از نی",
                urlSlug: "masnavi-2",
                plainText: "بشنو از نی چون حکایت می‌کند\nوز جدایی‌ها شکایت می‌کند\n",
                htmlText: "<p>بشنو از نی چون حکایت می‌کند<br>وز جدایی‌ها شکایت می‌کند</p>",
                poet: Poet(
                    id: 8,
                    name: "مولوی",
                    description: "شاعر و عارف بزرگ",
                    birthYear: 1207,
                    deathYear: 1273
                ),
                category: Category(
                    id: 3,
                    title: "مثنوی",
                    urlSlug: "masnavi",
                    parentId: nil
                )
            ),
            Poem(
                id: 9,
                title: "بنی آدم اعضای یکدیگرند",
                urlSlug: "ghazal-4",
                plainText: "بنی آدم اعضای یکدیگرند\nکه در آفرینش ز یک گوهرند\n",
                htmlText: "<p>بنی آدم اعضای یکدیگرند<br>که در آفرینش ز یک گوهرند</p>",
                poet: Poet(
                    id: 9,
                    name: "سعدی",
                    description: "شاعر و نویسنده بزرگ ایرانی",
                    birthYear: 1210,
                    deathYear: 1291
                ),
                category: Category(
                    id: 1,
                    title: "غزل",
                    urlSlug: "ghazal",
                    parentId: nil
                )
            ),
            Poem(
                id: 10,
                title: "ای کاش که جای آشنایی",
                urlSlug: "robai-4",
                plainText: "ای کاش که جای آشنایی بودی\nیا در ره منزل آشنایی بودی\n",
                htmlText: "<p>ای کاش که جای آشنایی بودی<br>یا در ره منزل آشنایی بودی</p>",
                poet: Poet(
                    id: 10,
                    name: "فردوسی",
                    description: "شاعر حماسه‌سرای ایرانی",
                    birthYear: 940,
                    deathYear: 1020
                ),
                category: Category(
                    id: 2,
                    title: "رباعی",
                    urlSlug: "robai",
                    parentId: nil
                )
            )
        ]
        
        // Return shuffled poems for variety
        return allPoems.shuffled()
    }
}
